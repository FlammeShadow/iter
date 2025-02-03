///|
pub fn next[A](self : T[A]) -> A? {
  let a = (self.run)()
  a
}

///|
pub fn peek[A](self : T[A]) -> A? {
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
pub fn count[A](self : T[A]) -> Int {
  let mut i = 0
  loop self.next() {
    Some(_) => {
      i += 1
      continue self.next()
    }
    None => break
  }
  i
}

///|
pub fn take[A](self : T[A], n : Int) -> T[A] {
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
pub fn take_while[A](self : T[A], f : (A) -> Bool) -> T[A] {
  let mut end = false
  let it = {
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
  it
}

///|
pub fn drop[A](self : T[A], n : Int) -> T[A] {
  let mut i = 0
  while i < n {
    i += 1
    (self.run)() |> ignore
  }
  { run: fn() { (self.run)() } }
}

///|
pub fn drop_while[A](self : T[A], f : (A) -> Bool) -> T[A] {
  let mut end = false
  while not(end) {
    match (self.run)() {
      None => break
      Some(v) => if f(v) { continue } else { end = true }
    }
  }
  { run: fn() { (self.run)() } }
}

///|
pub fn collect[A](self : T[A]) -> Array[A] {
  let array = Array::new(capacity=16)
  loop self.next() {
    Some(v) => {
      array.push(v)
      continue self.next()
    }
    None => break
  }
  array
}

///|
pub fn each[A](self : T[A], f : (A) -> Unit) -> Unit {
  loop self.next() {
    Some(v) => {
      f(v)
      continue self.next()
    }
    None => break
  }
}

///|
pub fn eachi[A](self : T[A], f : (Int, A) -> Unit) -> Unit {
  let mut i = 0
  loop self.next() {
    Some(v) => {
      f(i, v)
      i += 1
      continue self.next()
    }
    None => break
  }
}

///|
pub fn join[A : Show](self : T[A], separator~ : String) -> String {
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
    None => break
  }
  builder.to_string()
}

///|
pub fn find_first[A](self : T[A], f : (A) -> Bool) -> A? {
  loop self.next() {
    Some(v) => {
      if f(v) {
        break Some(v)
      }
      continue self.next()
    }
    None => None
  }
}

///|
pub fn fold[A, B](self : T[A], init : B, f : (B, A) -> B) -> B {
  let mut acc = init
  loop self.next() {
    Some(v) => {
      acc = f(acc, v)
      continue self.next()
    }
    None => acc
  }
}
