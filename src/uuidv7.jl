function uuidv7()
  # random bytes
  value = rand(UInt8, 16)

  # current timestamp
  timestamp = trunc(UInt64, time() * 1000)
  digits!(UInt8[0, 0, 0, 0, 0, 0, 0, 0], hton(timestamp), base=256) |> x -> copyto!(value, 1, x, 3, 6)

  # version and variant
  value[7] = value[7] & 0x0F | 0x70
  value[9] = value[9] & 0x3F | 0x80

  value
end

uuidv7() |> bytes2hex |> println
