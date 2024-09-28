import gleam/int
import gleam/io

@external(erlang, "crypto", "strong_rand_bytes")
pub fn strong_random_bytes(a: Int) -> BitArray

@external(erlang, "os", "system_time")
pub fn system_time(time_unit: Int) -> Int

pub fn uuiv7() -> BitArray {
  let assert <<a:size(12), b:size(62), _:size(6)>> = strong_random_bytes(10)

  let timestamp = system_time(1000)
  let version = 7
  let var = 10

  <<timestamp:48, version:4, a:12, var:2, b:62>>
}

pub fn to_string(ints: BitArray) -> String {
  to_base16(ints, 0, "")
}

fn to_base16(ints: BitArray, position: Int, acc: String) -> String {
  case position {
    8 | 13 | 18 | 23 -> to_base16(ints, position + 1, acc)
    _ ->
      case ints {
        <<i:size(4), rest:bits>> -> {
          to_base16(rest, position + 1, acc <> int.to_base16(i))
        }
        _ -> acc
      }
  }
}

pub fn main() {
  let uuid = uuiv7()
  io.debug(to_string(uuid))
}
