///|
test {
  let iter = [1, 2, 3, 4, 5] |> from_array
  let arr = []
  while iter.next() is Some(v) && v <= 3 {
    arr.push(v)
  }
  assert_eq!(arr, [1, 2, 3])
}
