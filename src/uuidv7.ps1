function New-Uuidv7
{
  
  # random bytes
  $value = [byte[]]::new(16)
  [System.Random]::new().NextBytes($value)

  # current timestamp
  $timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
  $value[0] = ($timestamp -shr 40) -band 0xFF
  $value[1] = ($timestamp -shr 32) -band 0xFF
  $value[2] = ($timestamp -shr 24) -band 0xFF
  $value[3] = ($timestamp -shr 16) -band 0xFF
  $value[4] = ($timestamp -shr 8) -band 0xFF
  $value[5] = $timestamp -band 0xFF

  # version and variant
  $value[6] = ($value[6] -band 0x0F) -bor 0x70
  $value[8] = ($value[8] -band 0x0F) -bor 0x80

  $value
}

(New-Uuidv7 | ForEach-Object ToString x2) -join ''

