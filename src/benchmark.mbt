///|
let arr : Array[Int] = range(1, end=10000, inclusive=true).collect()

///|
fn each_by_fold[A](iter : T[A], f : (A) -> Unit) -> Unit {
  iter.fold(init=(), fn(acc, x) {
    f(x)
    acc
  })
}

///|
pub fn test_each_by_fold() -> Unit {
  let iter = from_array(arr)
  each_by_fold(iter, fn(x) { ignore(x) })
}

///|
pub fn test_each() -> Unit {
  let iter = from_array(arr)
  iter.each(fn(x) { ignore(x) })
}

///|
pub fn test_iter_each() -> Unit {
  let iter = arr.iter()
  iter.each(fn(x) { ignore(x) })
}

///|
fn each_by_map[A](iter : T[A], f : (A) -> Unit) -> Unit {
  let iter = iter.map(fn(x) { f(x) })
  loop iter.next() {
    Some(_) => continue iter.next()
    None => break
  }
}

///|
pub fn test_each_by_map() -> Unit {
  let iter = from_array(arr)
  each_by_map(iter, fn(x) { ignore(x) })
}

///|
fn collect_by_fold[A](iter : T[A]) -> Array[A] {
  iter.fold(init=[], fn(acc, x) {
    acc.push(x)
    acc
  })
}

///|
pub fn test_collect() -> Unit {
  let iter = from_array(arr)
  iter.collect() |> ignore
}

///|
pub fn test_collect_by_fold() -> Unit {
  let iter = from_array(arr)
  collect_by_fold(iter) |> ignore
}

///|
pub fn test_iter_collect() -> Unit {
  let iter = arr.iter()
  iter.collect() |> ignore
}

///|
fn filter_by_fold[A](iter : T[A], f : (A) -> Bool) -> Array[A] {
  iter.fold(init=[], fn(acc, x) {
    if f(x) {
      acc.push(x)
    }
    acc
  })
}

///|
pub fn test_filter_by_fold() -> Unit {
  let iter = from_array(arr)
  filter_by_fold(iter, fn(x) { x % 2 == 0 }) |> ignore
}

///|
pub fn test_filter() -> Unit {
  let iter = from_array(arr)
  iter.filter(fn(x) { x % 2 == 0 }) |> ignore
}

///|
pub fn test_iter_filter() -> Unit {
  let iter = arr.iter()
  iter.filter(fn(x) { x % 2 == 0 }) |> ignore
}

fn span_by_iter[T](iter : Iter[T], f : (T) -> Bool) -> (Iter[T], Iter[T]) {
  (iter.take_while(f), iter.drop_while(f))
}

pub fn test_span_by_iter() -> Unit {
  let (even, odd) = span_by_iter(arr.iter(), fn(x) { x < 5000 })
  even.collect() |> ignore
  odd.collect() |> ignore
}

pub fn test_span() -> Unit {
  let (even, odd) = from_array(arr).span(fn(x) { x < 5000 })
  odd.collect() |> ignore
  even.collect() |> ignore
}
