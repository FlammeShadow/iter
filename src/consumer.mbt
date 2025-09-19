///|
/// Consumes the next value.
pub fn[A] next(self : T[A]) -> A? {
  (self.run)()
}

///|
pub fn[A] peek(self : T[A]) -> A? {
  match (self.run)() {
    None => None
    Some(v) => {
      let used = false
      let run = self.run
      self.run = fn() {
        match used {
          true => run()
          false => Some(v)
        }
      }
      Some(v)
    }
  }
}

///|
/// Consumes the iterator, returning the last value.
pub fn[A] last(self : T[A]) -> A? {
  loop (None, self.next()) {
    (_, Some(v)) => continue (Some(v), self.next())
    (v, None) => v
  }
}

///|
/// Consumes the iterator, counting and returning the number of iterations.
pub fn[A] count(self : T[A]) -> Int {
  let mut i = 0
  loop self.next() {
    Some(_) => {
      i += 1
      continue self.next()
    }
    None => i
  }
}

///|
/// Takes the first `n` elements from the iterator.
pub fn[A] take(self : T[A], n : Int) -> T[A] {
  let mut i = 0
  {
    run: fn() {
      if i < n {
        match (self.run)() {
          None => None
          Some(v) => {
            i += 1
            Some(v)
          }
        }
      } else {
        None
      }
    },
  }
}

///|
/// Takes elements from the iterator while the predicate returns `true`.
pub fn[A] take_while(self : T[A], f : (A) -> Bool) -> T[A] {
  let mut end = false
  {
    run: fn() {
      if not(end) {
        match (self.run)() {
          None => None
          Some(v) =>
            if f(v) {
              Some(v)
            } else {
              end = true
              None
            }
        }
      } else {
        None
      }
    },
  }
}

///|
/// Drops the first `n` elements from the iterator.
/// 
/// Note: The function is lazy, which only skips elements when it is requested.
pub fn[A] drop(self : T[A], n : Int) -> T[A] {
  let mut i : Int = 0
  let mut dropped = false
  {
    run: fn() {
      if not(dropped) {
        while i < n {
          i += 1
          (self.run)() |> ignore
        }
        dropped = true
        (self.run)()
      } else {
        (self.run)()
      }
    },
  }
}

///|
/// Skips elements from the iterator while the predicate returns `true`.
/// 
/// Note: The function is lazy, which only skips elements when it is requested.
pub fn[A] drop_while(self : T[A], f : (A) -> Bool) -> T[A] {
  let mut dropped = false
  {
    run: fn() {
      if not(dropped) {
        while self.next() is Some(v) && not(dropped) {
          if f(v) {
            continue
          } else {
            dropped = true
          }
        }
        (self.run)()
      } else {
        (self.run)()
      }
    },
  }
}

///|
/// Collects the elements of the iterator into an array.
pub fn[A] collect(self : T[A]) -> Array[A] {
  let array = Array::new()
  while self.next() is Some(v) {
    array.push(v)
  }
  array
}

///|
/// Applies `f` to each element of the iterator.
pub fn[A] each(self : T[A], f : (A) -> Unit) -> Unit {
  while self.next() is Some(v) {
    f(v)
  }
}

///|
/// Applies `f` to each element of the iterator, passing the index as a parameter.
pub fn[A] eachi(self : T[A], f : (Int, A) -> Unit) -> Unit {
  let mut i = 0
  while self.next() is Some(v) {
    f(i, v)
    i += 1
  }
}

///|
/// Concatenates the elements of the iterator into a string, separated by `separator`.
pub fn[A : Show] join(self : T[A], separator~ : String) -> String {
  let builder = StringBuilder::new()
  match self.next() {
    Some(v) => builder.write_string("\{v}")
    None => return ""
  }
  loop self.next() {
    Some(v) => {
      builder.write_string(separator)
      builder.write_string(v.to_string())
      continue self.next()
    }
    None => builder.to_string()
  }
}

///|
/// Finds the first element in the iterator that satisfies the predicate, or `None` if no such element is found.
pub fn[A] find_first(self : T[A], pred : (A) -> Bool) -> A? {
  while self.next() is Some(v) {
    if pred(v) {
      break Some(v)
    }
  } else {
    None
  }
}

///|
/// Folds the elements of the iterator using the given function, starting with the given initial value.
pub fn[A, B] fold(self : T[A], init~ : B, f : (B, A) -> B) -> B {
  let mut acc = init
  loop self.next() {
    Some(v) => {
      acc = f(acc, v)
      continue self.next()
    }
    None => acc
  }
}

///|
/// Returns the nth element of the iterator, or `None` if there isn't one.
pub fn[A] nth(self : T[A], n : Int) -> A? {
  self.drop(n).peek()
}

///|
/// Returns the maximum element of the iterator, or `None` if the iterator is empty.
pub fn[A : Compare] minimum(self : T[A]) -> A? {
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
/// Returns the minimum element of the iterator, or `None` if the iterator is empty.
pub fn[A : Compare] maximum(self : T[A]) -> A? {
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
pub impl[A : Show] Show for T[A] with output(self, logger) {
  logger.write_iter(self.iter())
}
