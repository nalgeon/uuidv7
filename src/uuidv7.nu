def "random uuid v7" [] {
  # timestamp in ms
  let timestamp_ms = (date now | into int) // 1_000_000
  let timestamp = $timestamp_ms | into binary | bytes at 0..=5 | bytes reverse

  # random bytes 
  let rand =  1..=10 | each { random int 0..=255 | into binary | bytes at 0..=0  } | bytes collect

  # version and variant
  let version = $rand | bytes at 0..=0 | bits and 0x[0F] | bits or 0x[70]
  let variant = $rand | bytes at 2..=2 | bits and 0x[3F] | bits or 0x[80]

  [ $timestamp $version ($rand | bytes at 1..=1) $variant ($rand | bytes at 3..) ] | bytes collect
}

random uuid v7 | encode hex
