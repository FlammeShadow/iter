///|
/// Transforms the elements of the iterator using `f`.
pub fn map[A, B](self : T[A], f : (A) -> B) -> T[B] {
  {
    run: fn() {
      match (self.run)() {
        None => None
        Some(v) => Some(f(v))
      }
    },
  }
}

///| 
pub fn mapi[A, B](self : T[A], f : (Int, A) -> B) -> T[B] {
  let mut i = 0
  {
    run: fn() {
      match (self.run)() {
        None => None
        Some(v) => {
          let result = Some(f(i, v))
          i += 1
          result
        }
      }
    },
  }
}

///|
/// Zips two iterators into an iterator of pairs.
pub fn zip[A, B](self : T[A], other : T[B]) -> T[(A, B)] {
  {
    run: fn() {
      match self.next() {
        None => None
        Some(v) =>
          match other.next() {
            None => None
            Some(w) => Some((v, w))
          }
      }
    },
  }
}

///|
pub fn filter[A](self : T[A], f : (A) -> Bool) -> T[A] {
  {
    run: fn() {
      loop self.next() {
        Some(v) => if f(v) { return Some(v) } else { continue self.next() }
        None => None
      }
    },
  }
}

///|
/// Transforms the elements of the iterator using `f` ignoring `None`.
pub fn filter_map[A, B](self : T[A], f : (A) -> B?) -> T[B] {
  {
    run: fn() {
      loop self.next() {
        Some(v) =>
          match f(v) {
            Some(w) => Some(w)
            None => continue self.next()
          }
        None => None
      }
    },
  }
}

///|
pub fn iter[A](self : T[A]) -> Iter[A] {
  Iter::new(fn(yield_) {
    loop (self.run)() {
      Some(v) => {
        guard yield_(v) is IterContinue else { break IterEnd }
        continue self.next()
      }
      None => IterEnd
    }
  })
}

///|
pub fn iter2[A, B](self : T[(A, B)]) -> Iter2[A, B] {
  Iter2::new(fn(yield_) {
    loop (self.run)() {
      Some((v, w)) => {
        guard yield_(v, w) is IterContinue else { break IterEnd }
        continue self.next()
      }
      None => IterEnd
    }
  })
}

///|
/// Creates a new iterator which places `separator` between adjacent items of the original one.
pub fn intersperse[A](self : T[A], sep : A) -> T[A] {
  let mut insert = false
  {
    run: fn() {
      if insert {
        insert = false
        Some(sep)
      } else {
        match (self.run)() {
          None => None
          Some(v) => {
            insert = true
            Some(v)
          }
        }
      }
    },
  }
}

///|
/// Transforms each element of the iterator into an iterator and flattens the resulting iterators into a single iterator.
pub fn flat_map[A, B](self : T[A], f : (A) -> T[B]) -> T[B] {
  let mut it = empty()
  {
    run: fn() {
      match it.next() {
        None =>
          match self.next() {
            None => None
            Some(v) => {
              it = f(v)
              it.next()
            }
          }
        Some(v) => Some(v)
      }
    },
  }
}

///|
/// Flattens an iterator of iterators into a single iterator.
pub fn flatten[A](self : T[T[A]]) -> T[A] {
  self.flat_map(fn(x) { x })
}

///|
/// Concatenates two iterators by appending the elements of the second iterator to the first.
pub fn concat[A](self : T[A], other : T[A]) -> T[A] {
  {
    run: fn() {
      match (self.run)() {
        None => (other.run)()
        Some(v) => Some(v)
      }
    },
  }
}

///|
pub fn op_add[A](self : T[A], other : T[A]) -> T[A] {
  self.concat(other)
}
