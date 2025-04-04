# YumeXi/iter

An external iterator library for MoonBit.

## Examples

```moonbit
fn main {
  let iter = [1, 2, 3, 4, 5] |> @iter.from_array
  while iter.next() is Some(v) && v <= 3 {
    println(v)
  } // => [1, 2, 3]
}
```

## TODOs

- [ ] Add more examples.
- [ ] Add conversion functions to builtin types.
  - Better conversion from/to internal iterator?
