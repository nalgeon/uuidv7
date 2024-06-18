function uuidv7()
  # random bytes
  value = rand(UInt8, 16)

  # current timestamp
  timestamp = trunc(UInt64, time() * 1000)

  # timestamp
  value[1:6] = [
    timestamp >> 40 & 0xFF,
    timestamp >> 32 & 0xFF,
    timestamp >> 24 & 0xFF,
    timestamp >> 16 & 0xFF,
    timestamp >> 8 & 0xFF,
    timestamp & 0xFF
  ]

  # version and variant
  value[7] = value[7] & 0x0F | 0x70
  value[9] = value[9] & 0x3F | 0x80

  value
end

uuidv7() |> bytes2hex |> println
