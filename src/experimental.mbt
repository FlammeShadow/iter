/// Experimental functions, maybe removed or changed in the future.

///|
pub fn range_by[A : Compare](start : A, end? : A, step~ : (A) -> A) -> T[A] {
  let mut a = start
  {
    run: match end {
      Some(end) =>
        fn() {
          if a < end {
            let result = Some(a)
            a = step(a)
            result
          } else {
            None
          }
        }
      None =>
        fn() {
          let result = Some(a)
          a = step(a)
          result
        }
    },
  }
}

///|
pub fn try_collect![A, E : Error](self : T[Result[A, E]]) -> Array[A]!E {
  let array = Array::new(capacity=16)
  loop self.next() {
    Some(v) => {
      match v {
        Ok(v) => array.push(v)
        Err(e) => raise e
      }
      continue self.next()
    }
    None => array
  }
}

///|
pub fn min[A : Compare](self : T[A]) -> A? {
  let mut min = None
  loop self.next() {
    Some(v) => {
      match min {
        None => min = Some(v)
        Some(min_v) => if v < min_v { min = Some(v) }
      }
      continue self.next()
    }
    None => min
  }
}

///|
pub fn max[A : Compare](self : T[A]) -> A? {
  let mut max = None
  loop self.next() {
    Some(v) => {
      match max {
        None => max = Some(v)
        Some(max_v) => if v > max_v { max = Some(v) }
      }
      continue self.next()
    }
    None => max
  }
}
