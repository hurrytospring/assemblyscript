import { DEBUG, BLOCK_OVERHEAD, BLOCK } from "rt/common";
import { Block, freeBlock, ROOT } from "rt/tlsf";
import { RTTIFlags } from "common/rtti";

/////////////////////////// A Pure Reference Counting Garbage Collector ///////////////////////////
// see:     https://researcher.watson.ibm.com/researcher/files/us-bacon/Bacon03Pure.pdf

// ╒══════════════════════ GC Info structure ══════════════════════╕
// │  3                   2                   1                    │
// │1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0│
// ├─┼─┴─┴─┼─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┤
// │B│color│                     refCount                          │
// └─┴─────┴───────────────────────────────────────────────────────┘
// B: buffered

// @ts-ignore: decorator
@inline const BUFFERED_MASK: u32 = 1 << (sizeof<u32>() * 8 - 1);
// @ts-ignore: decorator
@inline const COLOR_BITS = 3;
// @ts-ignore: decorator
@inline const COLOR_SHIFT: u32 = ctz(BUFFERED_MASK) - COLOR_BITS;
// @ts-ignore: decorator
@inline const COLOR_MASK: u32 = ((1 << COLOR_BITS) - 1) << COLOR_SHIFT;
// @ts-ignore: decorator
@inline const REFCOUNT_MASK: u32 = (1 << COLOR_SHIFT) - 1;

// ╒════════╤═══════════════════ Colors ═══════════════════════════╕
// │ Color  │ Meaning                                              │
// ├────────┼──────────────────────────────────────────────────────┤
// │ BLACK  │ In use or free                                       │
// │ GRAY   │ Possible member of cycle                             │
// │ WHITE  │ Member of garbage cycle                              │
// │ PURPLE │ Possible root of cycle                               │
// │ RED    │ Candidate cycle undergoing Σ-computation *concurrent │
// │ ORANGE │ Candidate cycle awaiting epoch boundary  *concurrent │
// └────────┴──────────────────────────────────────────────────────┘
// Acyclic detection has been decoupled, hence no GREEN.

// @ts-ignore: decorator
@inline const COLOR_BLACK: u32 = 0 << COLOR_SHIFT;
// @ts-ignore: decorator
@inline const COLOR_GRAY: u32 = 1 << COLOR_SHIFT;
// @ts-ignore: decorator
@inline const COLOR_WHITE: u32 = 2 << COLOR_SHIFT;
// @ts-ignore: decorator
@inline const COLOR_PURPLE: u32 = 3 << COLOR_SHIFT;
// @ts-ignore: decorator
@inline const COLOR_RED: u32 = 4 << COLOR_SHIFT;
// @ts-ignore: decorator
@inline const COLOR_ORANGE: u32 = 5 << COLOR_SHIFT;

// @ts-ignore: decorator
@inline const VISIT_DECREMENT = 1; // guard 0
// @ts-ignore: decorator
@inline const VISIT_MARKGRAY = 2;
// @ts-ignore: decorator
@inline const VISIT_SCAN = 3;
// @ts-ignore: decorator
@inline const VISIT_SCANBLACK = 4;
// @ts-ignore: decorator
@inline const VISIT_COLLECTWHITE = 5;

// @ts-ignore: decorator
@global
function __visit(ref: usize, cookie: i32): void {
  if (ref < HEAP_BASE) return;
  var s = changetype<Block>(ref - BLOCK_OVERHEAD);
  switch (cookie) {
    case VISIT_DECREMENT: {
      decrement(s);
      break;
    }
    case VISIT_MARKGRAY: {
      if (DEBUG) assert((s.gcInfo & REFCOUNT_MASK) > 0);
      s.gcInfo = s.gcInfo - 1;
      markGray(s);
      break;
    }
    case VISIT_SCAN: {
      scan(s);
      break;
    }
    case VISIT_SCANBLACK: {
      let info = s.gcInfo;
      assert((info & ~REFCOUNT_MASK) == ((info + 1) & ~REFCOUNT_MASK)); // overflow
      s.gcInfo = info + 1;
      if ((info & COLOR_MASK) != COLOR_BLACK) {
        scanBlack(s);
      }
      break;
    }
    case VISIT_COLLECTWHITE: {
      collectWhite(s);
      break;
    }
    default: if (DEBUG) assert(false);
  }
}

/** Increments the reference count of the specified block by one.*/
function increment(s: Block): void {
  var info = s.gcInfo;
  assert((info & ~REFCOUNT_MASK) == ((info + 1) & ~REFCOUNT_MASK)); // overflow
  s.gcInfo = info + 1;
}

/** Decrements the reference count of the specified block by one, possibly freeing it. */
function decrement(s: Block): void {
  var info = s.gcInfo;
  var rc = info & REFCOUNT_MASK;
  if (rc == 1) {
    __visit_members(changetype<usize>(s) + BLOCK_OVERHEAD, VISIT_DECREMENT);
    if (!(info & BUFFERED_MASK)) {
      freeBlock(ROOT, s);
    } else {
      s.gcInfo = BUFFERED_MASK | COLOR_BLACK | 0;
    }
  } else {
    if (DEBUG) assert(rc > 0);
    if (!(__typeinfo(s.rtId) & RTTIFlags.ACYCLIC)) {
      s.gcInfo = BUFFERED_MASK | COLOR_PURPLE | (rc - 1);
      if (!(info & BUFFERED_MASK)) {
        appendRoot(s);
      }
    } else {
      s.gcInfo = (info & ~REFCOUNT_MASK) | (rc - 1);
    }
  }
}

/** Buffer of possible roots. */
// @ts-ignore: decorator
@lazy var ROOTS: usize;
/** Current absolute offset into the `ROOTS` buffer. */
// @ts-ignore: decorator
@lazy var CUR: usize = 0;
/** Current absolute end offset into the `ROOTS` buffer. */
// @ts-ignore: decorator
@lazy var END: usize = 0;

/** Appends a block to possible roots. */
function appendRoot(s: Block): void {
  var cur = CUR;
  if (cur >= END) {
    growRoots(); // TBD: either that or pick a default and force collection on overflow
    cur = CUR;
  }
  store<Block>(cur, s);
  CUR = cur + 1;
}

/** Grows the roots buffer if it ran full. */
function growRoots(): void {
  var oldRoots = ROOTS;
  var oldSize = CUR - oldRoots;
  var newSize = max(oldSize * 2, 64 << alignof<usize>());
  var newRoots = memory.allocate(newSize);
  memory.copy(newRoots, oldRoots, oldSize);
  ROOTS = newRoots;
  CUR = newRoots + oldSize;
  END = newRoots + newSize;
}

/** Collects cyclic garbage. */
// @ts-ignore: decorator
@global @unsafe
export function __collect(): void {

  // markRoots
  var roots = ROOTS;
  var cur = roots;
  for (let pos = cur, end = CUR; pos < end; pos += sizeof<usize>()) {
    let s = load<Block>(pos);
    let info = s.gcInfo;
    if ((info & COLOR_MASK) == COLOR_PURPLE && (info & REFCOUNT_MASK) > 0) {
      markGray(s);
      store<Block>(cur, s);
      cur += sizeof<usize>();
    } else {
      if ((info & COLOR_MASK) == COLOR_BLACK && !(info & REFCOUNT_MASK)) {
        freeBlock(ROOT, s);
      } else {
        s.gcInfo = info & ~BUFFERED_MASK;
      }
    }
  }
  CUR = cur;

  // scanRoots
  for (let pos = roots; pos < cur; pos += sizeof<usize>()) {
    scan(load<Block>(pos));
  }

  // collectRoots
  for (let pos = roots; pos < cur; pos += sizeof<usize>()) {
    let s = load<Block>(pos);
    s.gcInfo = s.gcInfo & ~BUFFERED_MASK;
    collectWhite(s);
  }
  CUR = roots;
}

/** Marks a block as gray (possible member of cycle) during the collection phase. */
function markGray(s: Block): void {
  var info = s.gcInfo;
  if ((info & COLOR_MASK) != COLOR_GRAY) {
    s.gcInfo = (info & ~COLOR_MASK) | COLOR_GRAY;
    __visit_members(changetype<usize>(s) + BLOCK_OVERHEAD, VISIT_MARKGRAY);
  }
}

/** Scans a block during the collection phase, determining whether it is garbage or not. */
function scan(s: Block): void {
  var info = s.gcInfo;
  if ((info & COLOR_MASK) == COLOR_GRAY) {
    if ((info & REFCOUNT_MASK) > 0) {
      scanBlack(s);
    } else {
      s.gcInfo = (info & ~COLOR_MASK) | COLOR_WHITE;
      __visit_members(changetype<usize>(s) + BLOCK_OVERHEAD, VISIT_SCAN);
    }
  }
}

/** Marks a block as black (in use) if it was found to be reachable during the collection phase. */
function scanBlack(s: Block): void {
  s.gcInfo = (s.gcInfo & ~COLOR_MASK) | COLOR_BLACK;
  __visit_members(changetype<usize>(s) + BLOCK_OVERHEAD, VISIT_SCANBLACK);
}

/** Collects all white (member of a garbage cycle) nodes when completing the collection phase.  */
function collectWhite(s: Block): void {
  var info = s.gcInfo;
  if ((info & COLOR_MASK) == COLOR_WHITE && !(info & BUFFERED_MASK)) {
    // s.gcInfo = (info & ~COLOR_MASK) | COLOR_BLACK;
    __visit_members(changetype<usize>(s) + BLOCK_OVERHEAD, VISIT_COLLECTWHITE);
  }
  freeBlock(ROOT, s);
}

// @ts-ignore: decorator
@global @unsafe
export function __retain(ref: usize): usize {
  if (ref > HEAP_BASE) increment(changetype<Block>(ref - BLOCK_OVERHEAD));
  return ref;
}

// @ts-ignore: decorator
@global @unsafe
export function __release(ref: usize): void {
  if (ref > HEAP_BASE) decrement(changetype<Block>(ref - BLOCK_OVERHEAD));
}

// @ts-ignore: decorator
@global @unsafe
export function __retainRelease(ref: usize, oldRef: usize): usize {
  if (ref != oldRef) {
    let heapBase = HEAP_BASE;
    if (ref > heapBase) increment(changetype<Block>(ref - BLOCK_OVERHEAD));
    if (oldRef > heapBase) decrement(changetype<Block>(oldRef - BLOCK_OVERHEAD));
  }
  return ref;
}