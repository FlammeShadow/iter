// Experimental functions, maybe removed or changed in the future.

///|
/// Creates an iterator starts from init and extends by step, until `cond` returns `false`.
/// 
/// **Note: experimental function**
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

///|
fn unfold_[A, S](state~ : S, step~ : (S) -> (A, S)?) -> Array[A] {
  match step(state) {
    Some((v, state)) => [v, ..unfold_(state~, step~)]
    None => []
  }
}

///|
/// **Note: experimental function**
pub fn unfold_eager[A, S](state~ : S, step~ : (S) -> (A, S)?) -> T[A] {
  from_array(unfold_(state~, step~))
}

///|
/// **Note: experimental function**
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

///|
/// **Note: experimental function**
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
/// **Note: experimental function**
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

///|
/// Appends an element to the end of the iterator.
/// 
/// *Note*: The name might be subject to change, related issue: https://github.com/moonbitlang/core/issues/1511
pub fn append[A](self : T[A], other : A) -> T[A] {
  self.concat(singleton(other))
}

///|
/// Prepends an element to the beginning of the iterator.
/// 
/// *Note*: The name might be subject to change, related issue: https://github.com/moonbitlang/core/issues/1511
pub fn prepend[A](self : T[A], other : A) -> T[A] {
  singleton(other).concat(self)
}

///|
/// Splits the iterator into two parts at the first element for which `pred` returns `false`.
/// 
/// ## Returns
/// 
/// *Note that requesting the second part of the iterator will consume the first part.*
/// 
/// **Note: experimental function**
pub fn span[A](self : T[A], pred : (A) -> Bool) -> (T[A], T[A]) {
  let mut taken = false
  let left_array = []
  let mut left_i = 0
  let right_array = []
  let left = {
    run: fn() {
      if not(taken) {
        match self.next() {
          Some(v) =>
            if pred(v) {
              Some(v)
            } else {
              right_array.push(v)
              taken = true
              None
            }
          None => None
        }
      } else if left_i < left_array.length() {
        let result = Some(left_array[left_i])
        left_i += 1
        result
      } else {
        None
      }
    },
  }
  let right = {
    run: fn() {
      if not(taken) {
        loop self.next() {
          Some(v) =>
            if pred(v) {
              left_array.push(v)
              continue self.next()
            } else {
              taken = true
              return Some(v)
            }
          None => None
        }
      } else if not(right_array.is_empty()) {
        Some(right_array.remove(0))
      } else {
        let v = (self.run)()
        v
      }
    },
  }
  (left, right)
}

///|
test {
  let test_iter = range(1, end=20, inclusive=true)
  let (left, right) = test_iter.span(fn(n) { n <= 10 })
  assert_eq!(left.collect(), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
  assert_eq!(right.collect(), [11, 12, 13, 14, 15, 16, 17, 18, 19, 20])
  let test_iter = range(1, end=20, inclusive=true)
  let (left, right) = test_iter.span(fn(n) { n <= 10 })
  assert_eq!(right.collect(), [11, 12, 13, 14, 15, 16, 17, 18, 19, 20])
  assert_eq!(left.collect(), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
}
