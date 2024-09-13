function New-Uuidv7
{
  # random bytes
  $value = [byte[]]::new(16)
  [System.Random]::new().NextBytes($value)

  # current timestamp
  $timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
  [System.BitConverter]::GetBytes($timestamp)[5..0].Copyto($value, 0)

  # version and variant
  $value[6] = ($value[6] -band 0x0F) -bor 0x70
  $value[8] = ($value[8] -band 0x0F) -bor 0x80

  $value
}

(New-Uuidv7 | ForEach-Object ToString x2) -join ''
