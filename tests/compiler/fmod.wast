(module
 (type $FFF (func (param f64 f64) (result f64)))
 (type $fff (func (param f32 f32) (result f32)))
 (type $v (func))
 (global $f64.EPSILON f64 (f64.const 2.220446049250313e-16))
 (global $f32.EPSILON f32 (f32.const 1.1920928955078125e-07))
 (global $HEAP_BASE i32 (i32.const 4))
 (memory $0 1)
 (export "fmod" (func $fmod/fmod))
 (export "fmodf" (func $fmod/fmodf))
 (export "memory" (memory $0))
 (start $start)
 (func $fmod/fmod (; 0 ;) (type $FFF) (param $0 f64) (param $1 f64) (result f64)
  (local $2 i64)
  (local $3 i64)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  (local $7 f64)
  (local $8 i32)
  (local $9 i64)
  (block
   (set_local $2
    (i64.reinterpret/f64
     (get_local $0)
    )
   )
  )
  (block
   (set_local $3
    (i64.reinterpret/f64
     (get_local $1)
    )
   )
  )
  (block
   (set_local $4
    (i32.wrap/i64
     (i64.and
      (i64.shr_u
       (get_local $2)
       (i64.const 52)
      )
      (i64.const 2047)
     )
    )
   )
  )
  (block
   (set_local $5
    (i32.wrap/i64
     (i64.and
      (i64.shr_u
       (get_local $3)
       (i64.const 52)
      )
      (i64.const 2047)
     )
    )
   )
  )
  (block
   (set_local $6
    (i32.wrap/i64
     (i64.shr_u
      (get_local $2)
      (i64.const 63)
     )
    )
   )
  )
  (if
   (if (result i32)
    (tee_local $8
     (if (result i32)
      (tee_local $8
       (i64.eq
        (i64.shl
         (get_local $3)
         (i64.const 1)
        )
        (i64.const 0)
       )
      )
      (get_local $8)
      (f64.ne
       (tee_local $7
        (get_local $1)
       )
       (get_local $7)
      )
     )
    )
    (get_local $8)
    (i32.eq
     (get_local $4)
     (i32.const 2047)
    )
   )
   (return
    (f64.div
     (f64.mul
      (get_local $0)
      (get_local $1)
     )
     (f64.mul
      (get_local $0)
      (get_local $1)
     )
    )
   )
  )
  (if
   (i64.le_u
    (i64.shl
     (get_local $2)
     (i64.const 1)
    )
    (i64.shl
     (get_local $3)
     (i64.const 1)
    )
   )
   (block
    (if
     (i64.eq
      (i64.shl
       (get_local $2)
       (i64.const 1)
      )
      (i64.shl
       (get_local $3)
       (i64.const 1)
      )
     )
     (return
      (f64.mul
       (f64.const 0)
       (get_local $0)
      )
     )
    )
    (return
     (get_local $0)
    )
   )
  )
  (if
   (i32.eqz
    (get_local $4)
   )
   (block
    (block $break|0
     (block
      (set_local $9
       (i64.shl
        (get_local $2)
        (i64.const 12)
       )
      )
     )
     (loop $continue|0
      (if
       (i64.eqz
        (i64.shr_u
         (get_local $9)
         (i64.const 63)
        )
       )
       (block
        (set_local $4
         (i32.sub
          (get_local $4)
          (i32.const 1)
         )
        )
        (set_local $9
         (i64.shl
          (get_local $9)
          (i64.const 1)
         )
        )
        (br $continue|0)
       )
      )
     )
    )
    (set_local $2
     (i64.shl
      (get_local $2)
      (i64.add
       (i64.sub
        (i64.const 0)
        (i64.extend_u/i32
         (get_local $4)
        )
       )
       (i64.const 1)
      )
     )
    )
   )
   (block
    (set_local $2
     (i64.and
      (get_local $2)
      (i64.shr_u
       (i64.sub
        (i64.const 0)
        (i64.const 1)
       )
       (i64.const 12)
      )
     )
    )
    (set_local $2
     (i64.or
      (get_local $2)
      (i64.shl
       (i64.const 1)
       (i64.const 52)
      )
     )
    )
   )
  )
  (if
   (i32.eqz
    (get_local $5)
   )
   (block
    (block $break|1
     (set_local $9
      (i64.shl
       (get_local $3)
       (i64.const 12)
      )
     )
     (loop $continue|1
      (if
       (i64.eqz
        (i64.shr_u
         (get_local $9)
         (i64.const 63)
        )
       )
       (block
        (set_local $5
         (i32.sub
          (get_local $5)
          (i32.const 1)
         )
        )
        (set_local $9
         (i64.shl
          (get_local $9)
          (i64.const 1)
         )
        )
        (br $continue|1)
       )
      )
     )
    )
    (set_local $3
     (i64.shl
      (get_local $3)
      (i64.add
       (i64.sub
        (i64.const 0)
        (i64.extend_u/i32
         (get_local $5)
        )
       )
       (i64.const 1)
      )
     )
    )
   )
   (block
    (set_local $3
     (i64.and
      (get_local $3)
      (i64.shr_u
       (i64.sub
        (i64.const 0)
        (i64.const 1)
       )
       (i64.const 12)
      )
     )
    )
    (set_local $3
     (i64.or
      (get_local $3)
      (i64.shl
       (i64.const 1)
       (i64.const 52)
      )
     )
    )
   )
  )
  (block $break|2
   (nop)
   (loop $continue|2
    (if
     (i32.gt_s
      (get_local $4)
      (get_local $5)
     )
     (block
      (block
       (set_local $9
        (i64.sub
         (get_local $2)
         (get_local $3)
        )
       )
       (if
        (i64.eqz
         (i64.shr_u
          (get_local $9)
          (i64.const 63)
         )
        )
        (block
         (if
          (i64.eqz
           (get_local $9)
          )
          (return
           (f64.mul
            (f64.const 0)
            (get_local $0)
           )
          )
         )
         (set_local $2
          (get_local $9)
         )
        )
       )
       (set_local $2
        (i64.shl
         (get_local $2)
         (i64.const 1)
        )
       )
      )
      (drop
       (block (result i32)
        (set_local $8
         (get_local $4)
        )
        (set_local $4
         (i32.sub
          (get_local $8)
          (i32.const 1)
         )
        )
        (get_local $8)
       )
      )
      (br $continue|2)
     )
    )
   )
  )
  (set_local $9
   (i64.sub
    (get_local $2)
    (get_local $3)
   )
  )
  (if
   (i64.eqz
    (i64.shr_u
     (get_local $9)
     (i64.const 63)
    )
   )
   (block
    (if
     (i64.eqz
      (get_local $9)
     )
     (return
      (f64.mul
       (f64.const 0)
       (get_local $0)
      )
     )
    )
    (set_local $2
     (get_local $9)
    )
   )
  )
  (block $break|3
   (nop)
   (loop $continue|3
    (if
     (i64.eqz
      (i64.shr_u
       (get_local $2)
       (i64.const 52)
      )
     )
     (block
      (set_local $4
       (i32.sub
        (get_local $4)
        (i32.const 1)
       )
      )
      (set_local $2
       (i64.shl
        (get_local $2)
        (i64.const 1)
       )
      )
      (br $continue|3)
     )
    )
   )
  )
  (if
   (i32.gt_s
    (get_local $4)
    (i32.const 0)
   )
   (block
    (set_local $2
     (i64.sub
      (get_local $2)
      (i64.shl
       (i64.const 1)
       (i64.const 52)
      )
     )
    )
    (set_local $2
     (i64.or
      (get_local $2)
      (i64.shl
       (i64.extend_u/i32
        (get_local $4)
       )
       (i64.const 52)
      )
     )
    )
   )
   (set_local $2
    (i64.shr_u
     (get_local $2)
     (i64.add
      (i64.sub
       (i64.const 0)
       (i64.extend_u/i32
        (get_local $4)
       )
      )
      (i64.const 1)
     )
    )
   )
  )
  (set_local $2
   (i64.or
    (get_local $2)
    (i64.shl
     (i64.extend_u/i32
      (get_local $6)
     )
     (i64.const 63)
    )
   )
  )
  (return
   (f64.reinterpret/i64
    (get_local $2)
   )
  )
 )
 (func $fmod/fmodf (; 1 ;) (type $fff) (param $0 f32) (param $1 f32) (result f32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  (local $7 f32)
  (local $8 i32)
  (local $9 i32)
  (block
   (set_local $2
    (i32.reinterpret/f32
     (get_local $0)
    )
   )
  )
  (block
   (set_local $3
    (i32.reinterpret/f32
     (get_local $1)
    )
   )
  )
  (block
   (set_local $4
    (i32.and
     (i32.shr_u
      (get_local $2)
      (i32.const 23)
     )
     (i32.const 255)
    )
   )
  )
  (block
   (set_local $5
    (i32.and
     (i32.shr_u
      (get_local $3)
      (i32.const 23)
     )
     (i32.const 255)
    )
   )
  )
  (block
   (set_local $6
    (i32.and
     (get_local $2)
     (i32.const -2147483648)
    )
   )
  )
  (if
   (if (result i32)
    (tee_local $8
     (if (result i32)
      (tee_local $8
       (i32.eq
        (i32.shl
         (get_local $3)
         (i32.const 1)
        )
        (i32.const 0)
       )
      )
      (get_local $8)
      (f32.ne
       (tee_local $7
        (get_local $1)
       )
       (get_local $7)
      )
     )
    )
    (get_local $8)
    (i32.eq
     (get_local $4)
     (i32.const 255)
    )
   )
   (return
    (f32.div
     (f32.mul
      (get_local $0)
      (get_local $1)
     )
     (f32.mul
      (get_local $0)
      (get_local $1)
     )
    )
   )
  )
  (if
   (i32.le_u
    (i32.shl
     (get_local $2)
     (i32.const 1)
    )
    (i32.shl
     (get_local $3)
     (i32.const 1)
    )
   )
   (block
    (if
     (i32.eq
      (i32.shl
       (get_local $2)
       (i32.const 1)
      )
      (i32.shl
       (get_local $3)
       (i32.const 1)
      )
     )
     (return
      (f32.mul
       (f32.const 0)
       (get_local $0)
      )
     )
    )
    (return
     (get_local $0)
    )
   )
  )
  (if
   (i32.eqz
    (get_local $4)
   )
   (block
    (block $break|0
     (block
      (set_local $9
       (i32.shl
        (get_local $2)
        (i32.const 9)
       )
      )
     )
     (loop $continue|0
      (if
       (i32.eqz
        (i32.shr_u
         (get_local $9)
         (i32.const 31)
        )
       )
       (block
        (set_local $4
         (i32.sub
          (get_local $4)
          (i32.const 1)
         )
        )
        (set_local $9
         (i32.shl
          (get_local $9)
          (i32.const 1)
         )
        )
        (br $continue|0)
       )
      )
     )
    )
    (set_local $2
     (i32.shl
      (get_local $2)
      (i32.add
       (i32.sub
        (i32.const 0)
        (get_local $4)
       )
       (i32.const 1)
      )
     )
    )
   )
   (block
    (set_local $2
     (i32.and
      (get_local $2)
      (i32.shr_u
       (i32.sub
        (i32.const 0)
        (i32.const 1)
       )
       (i32.const 9)
      )
     )
    )
    (set_local $2
     (i32.or
      (get_local $2)
      (i32.shl
       (i32.const 1)
       (i32.const 23)
      )
     )
    )
   )
  )
  (if
   (i32.eqz
    (get_local $5)
   )
   (block
    (block $break|1
     (set_local $9
      (i32.shl
       (get_local $3)
       (i32.const 9)
      )
     )
     (loop $continue|1
      (if
       (i32.eqz
        (i32.shr_u
         (get_local $9)
         (i32.const 31)
        )
       )
       (block
        (set_local $5
         (i32.sub
          (get_local $5)
          (i32.const 1)
         )
        )
        (set_local $9
         (i32.shl
          (get_local $9)
          (i32.const 1)
         )
        )
        (br $continue|1)
       )
      )
     )
    )
    (set_local $3
     (i32.shl
      (get_local $3)
      (i32.add
       (i32.sub
        (i32.const 0)
        (get_local $5)
       )
       (i32.const 1)
      )
     )
    )
   )
   (block
    (set_local $3
     (i32.and
      (get_local $3)
      (i32.shr_u
       (i32.sub
        (i32.const 0)
        (i32.const 1)
       )
       (i32.const 9)
      )
     )
    )
    (set_local $3
     (i32.or
      (get_local $3)
      (i32.shl
       (i32.const 1)
       (i32.const 23)
      )
     )
    )
   )
  )
  (block $break|2
   (nop)
   (loop $continue|2
    (if
     (i32.gt_s
      (get_local $4)
      (get_local $5)
     )
     (block
      (block
       (set_local $9
        (i32.sub
         (get_local $2)
         (get_local $3)
        )
       )
       (if
        (i32.eqz
         (i32.shr_u
          (get_local $9)
          (i32.const 31)
         )
        )
        (block
         (if
          (i32.eqz
           (get_local $9)
          )
          (return
           (f32.mul
            (f32.const 0)
            (get_local $0)
           )
          )
         )
         (set_local $2
          (get_local $9)
         )
        )
       )
       (set_local $2
        (i32.shl
         (get_local $2)
         (i32.const 1)
        )
       )
      )
      (set_local $4
       (i32.sub
        (get_local $4)
        (i32.const 1)
       )
      )
      (br $continue|2)
     )
    )
   )
  )
  (set_local $9
   (i32.sub
    (get_local $2)
    (get_local $3)
   )
  )
  (if
   (i32.eqz
    (i32.shr_u
     (get_local $9)
     (i32.const 31)
    )
   )
   (block
    (if
     (i32.eqz
      (get_local $9)
     )
     (return
      (f32.mul
       (f32.const 0)
       (get_local $0)
      )
     )
    )
    (set_local $2
     (get_local $9)
    )
   )
  )
  (block $break|3
   (nop)
   (loop $continue|3
    (if
     (i32.eqz
      (i32.shr_u
       (get_local $2)
       (i32.const 23)
      )
     )
     (block
      (set_local $4
       (i32.sub
        (get_local $4)
        (i32.const 1)
       )
      )
      (set_local $2
       (i32.shl
        (get_local $2)
        (i32.const 1)
       )
      )
      (br $continue|3)
     )
    )
   )
  )
  (if
   (i32.gt_s
    (get_local $4)
    (i32.const 0)
   )
   (block
    (set_local $2
     (i32.sub
      (get_local $2)
      (i32.shl
       (i32.const 1)
       (i32.const 23)
      )
     )
    )
    (set_local $2
     (i32.or
      (get_local $2)
      (i32.shl
       (get_local $4)
       (i32.const 23)
      )
     )
    )
   )
   (set_local $2
    (i32.shr_u
     (get_local $2)
     (i32.add
      (i32.sub
       (i32.const 0)
       (get_local $4)
      )
      (i32.const 1)
     )
    )
   )
  )
  (set_local $2
   (i32.or
    (get_local $2)
    (get_local $6)
   )
  )
  (return
   (f32.reinterpret/i32
    (get_local $2)
   )
  )
 )
 (func $start (; 2 ;) (type $v)
  (local $0 f64)
  (local $1 f32)
  (if
   (i32.eqz
    (f64.ne
     (tee_local $0
      (call $fmod/fmod
       (f64.const 1)
       (f64.const nan:0x8000000000000)
      )
     )
     (get_local $0)
    )
   )
   (unreachable)
  )
  (if
   (i32.eqz
    (f64.eq
     (call $fmod/fmod
      (f64.const 1.5)
      (f64.const 1)
     )
     (f64.const 0.5)
    )
   )
   (unreachable)
  )
  (if
   (i32.eqz
    (f64.lt
     (f64.sub
      (call $fmod/fmod
       (f64.const 9.2)
       (f64.const 2)
      )
      (f64.const 1.2)
     )
     (f64.const 2.220446049250313e-16)
    )
   )
   (unreachable)
  )
  (if
   (i32.eqz
    (f64.lt
     (f64.sub
      (call $fmod/fmod
       (f64.const 9.2)
       (f64.const 3.7)
      )
      (f64.const 1.8)
     )
     (f64.const 2.220446049250313e-16)
    )
   )
   (unreachable)
  )
  (if
   (i32.eqz
    (f32.ne
     (tee_local $1
      (call $fmod/fmodf
       (f32.const 1)
       (f32.const nan:0x400000)
      )
     )
     (get_local $1)
    )
   )
   (unreachable)
  )
  (if
   (i32.eqz
    (f32.eq
     (call $fmod/fmodf
      (f32.const 1.5)
      (f32.const 1)
     )
     (f32.const 0.5)
    )
   )
   (unreachable)
  )
  (if
   (i32.eqz
    (f32.lt
     (f32.sub
      (call $fmod/fmodf
       (f32.const 9.199999809265137)
       (f32.const 2)
      )
      (f32.const 1.2000000476837158)
     )
     (f32.const 1.1920928955078125e-07)
    )
   )
   (unreachable)
  )
  (if
   (i32.eqz
    (f32.lt
     (f32.sub
      (call $fmod/fmodf
       (f32.const 9.199999809265137)
       (f32.const 3.700000047683716)
      )
      (f32.const 1.7999999523162842)
     )
     (f32.const 1.1920928955078125e-07)
    )
   )
   (unreachable)
  )
 )
)
(;
[program.elements]
  GLOBAL: NaN
  GLOBAL: Infinity
  FUNCTION_PROTOTYPE: isNaN
  FUNCTION_PROTOTYPE: isFinite
  FUNCTION_PROTOTYPE: clz
  FUNCTION_PROTOTYPE: ctz
  FUNCTION_PROTOTYPE: popcnt
  FUNCTION_PROTOTYPE: rotl
  FUNCTION_PROTOTYPE: rotr
  FUNCTION_PROTOTYPE: abs
  FUNCTION_PROTOTYPE: max
  FUNCTION_PROTOTYPE: min
  FUNCTION_PROTOTYPE: ceil
  FUNCTION_PROTOTYPE: floor
  FUNCTION_PROTOTYPE: copysign
  FUNCTION_PROTOTYPE: nearest
  FUNCTION_PROTOTYPE: reinterpret
  FUNCTION_PROTOTYPE: sqrt
  FUNCTION_PROTOTYPE: trunc
  FUNCTION_PROTOTYPE: load
  FUNCTION_PROTOTYPE: store
  FUNCTION_PROTOTYPE: sizeof
  FUNCTION_PROTOTYPE: select
  FUNCTION_PROTOTYPE: unreachable
  FUNCTION_PROTOTYPE: current_memory
  FUNCTION_PROTOTYPE: grow_memory
  FUNCTION_PROTOTYPE: parseInt
  FUNCTION_PROTOTYPE: parseFloat
  FUNCTION_PROTOTYPE: changetype
  FUNCTION_PROTOTYPE: assert
  FUNCTION_PROTOTYPE: i8
  FUNCTION_PROTOTYPE: i16
  FUNCTION_PROTOTYPE: i32
  FUNCTION_PROTOTYPE: i64
  FUNCTION_PROTOTYPE: u8
  FUNCTION_PROTOTYPE: u16
  FUNCTION_PROTOTYPE: u32
  FUNCTION_PROTOTYPE: u64
  FUNCTION_PROTOTYPE: bool
  FUNCTION_PROTOTYPE: f32
  FUNCTION_PROTOTYPE: f64
  FUNCTION_PROTOTYPE: isize
  FUNCTION_PROTOTYPE: usize
  GLOBAL: HEAP_BASE
  FUNCTION_PROTOTYPE: fmod/fmod
  FUNCTION_PROTOTYPE: fmod/fmodf
[program.exports]
  FUNCTION_PROTOTYPE: fmod/fmod
  FUNCTION_PROTOTYPE: fmod/fmodf
;)
