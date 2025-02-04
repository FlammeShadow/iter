// Experimental functions, maybe removed or changed in the future.

///| **NOTE: Experimental**
pub fn seq[A](init~ : A, step~ : (A) -> A, cond~ : (A) -> Bool) -> T[A] {
  let mut v = init
  {
    run: fn() {
      if cond(v) {
        let result = Some(v)
        v = step(v)
        result
      } else {
        None
      }
    },
  }
}

///| **NOTE: Experimental**
fn unfold_[A, S](state~ : S, step~ : (S) -> (A, S)?) -> Array[A] {
  match step(state) {
    Some((v, state)) => [v, ..unfold_(state~, step~)]
    None => []
  }
}

///| **NOTE: Experimental**
pub fn unfold_eager[A, S](state~ : S, step~ : (S) -> (A, S)?) -> T[A] {
  from_array(unfold_(state~, step~))
}

///| **NOTE: Experimental**
pub fn unfold[A, S](state~ : S, step~ : (S) -> (A, S)?) -> T[A] {
  let mut state = state
  {
    run: fn() {
      match step(state) {
        Some((v, state_)) => {
          state = state_
          Some(v)
        }
        None => None
      }
    },
  }
}

///| **NOTE: Experimental**
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

///| **NOTE: Experimental**
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

///| Appends an element to the end of the iterator.
/// 
/// *Note*: The name might be subject to change, related issue: https://github.com/moonbitlang/core/issues/1511
pub fn append[A](self : T[A], other : A) -> T[A] {
  self.concat(singleton(other))
}

///| Prepends an element to the beginning of the iterator.
/// 
/// *Note*: The name might be subject to change, related issue: https://github.com/moonbitlang/core/issues/1511
pub fn prepend[A](self : T[A], other : A) -> T[A] {
  singleton(other).concat(self)
}
