SELECT
  CONCAT(
    -- First 8 chars: high 32 bits of timestamp
    SUBSTRING(LPAD(LOWER(HEX(unix_millis(current_timestamp()))), 12, '0'), 1, 8),
    '-',
    -- Next 4 chars: low 16 bits of timestamp
    SUBSTRING(LPAD(LOWER(HEX(unix_millis(current_timestamp()))), 12, '0'), 9, 4),
    '-',
    -- Next 4 chars: version (7) + 12 bits of rand_a
    CONCAT(
      '7',
      LPAD(LOWER(HEX(CAST(RAND() * 4096 AS INT))), 3, '0')
    ),
    '-',
    -- Next 4 chars: variant (10) + 14 bits random
    LPAD(LOWER(HEX(CAST(RAND() * 16384 + 32768 AS INT))), 4, '0'),
    '-',
    -- Last 12 chars: 48 bits of random data
    LPAD(LOWER(HEX(CAST(RAND() * 281474976710656 AS BIGINT))), 12, '0')
  )
