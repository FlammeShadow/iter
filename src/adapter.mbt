///|
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
        guard let IterContinue = yield_(v) else { x => break x }
        continue self.next()
      }
      None => IterEnd
    }
  })
}

///|
pub fn iter2[A, B](self : T[(A, B)]) -> Iter2[A, B] {
  @builtin.Iter2::new(fn(yield_) {
    loop (self.run)() {
      Some((v, w)) => {
        guard let IterContinue = yield_(v, w) else { x => break x }
        continue self.next()
      }
      None => IterEnd
    }
  })
}

///|
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
pub fn flatten[A](self : T[T[A]]) -> T[A] {
  self.flat_map(fn(x) { x })
}

///|
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
