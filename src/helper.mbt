///|
pub fn new[A](next : () -> A?) -> T[A] {
  { run: next }
}

///|
/// Creates an iterator that generates values from a range.
pub fn range(
  start : Int,
  end? : Int,
  step~ : Int = 1,
  inclusive~ : Bool = false
) -> T[Int] {
  let mut i = start
  let end = if inclusive { end.map(fn(n) { n + step }) } else { end }
  {
    run: match end {
      Some(end) =>
        fn() {
          if i < end {
            let result = Some(i)
            i += step
            result
          } else {
            None
          }
        }
      None =>
        fn() {
          let result = Some(i)
          i += step
          result
        }
    },
  }
}

///|
/// Creates an iterator that generates values from an internal iterator.
pub fn from_iter[A](iter : Iter[A]) -> T[A] {
  let mut iter = iter
  {
    run: fn() {
      guard let None as v = iter.head() else {
        Some(_) as v => {
          iter = iter.drop(1)
          v
        }
      }
      v
    },
  }
}

///|
/// Creates an iterator that generates values from an array.
pub fn from_array[A](array : Array[A]) -> T[A] {
  let mut i = 0
  {
    run: fn() {
      if i < array.length() {
        i += 1
        array.get(i - 1)
      } else {
        None
      }
    },
  }
}

///|
/// Creates an empty iterator.
pub fn empty[A]() -> T[A] {
  { run: fn() { None } }
}

///|
/// Creates an iterator that contains a single element.
pub fn singleton[A](a : A) -> T[A] {
  let used = false
  {
    run: fn() {
      match used {
        true => None
        false => Some(a)
      }
    },
  }
}

///|
/// Creates an iterator that repeats a value indefinitely.
pub fn repeat[A](a : A) -> T[A] {
  { run: fn() { Some(a) } }
}

///|
/// Creates an iterator that repeats the result of executing a function indefinitely.
pub fn repeat_by[A](f : () -> A) -> T[A] {
  { run: fn() { Some(f()) } }
}
