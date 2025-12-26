-- UUIDv7 implementation for PySpark SQL.
-- License: Public Domain.

select
  printf('%08x-%04x-7%03x-%04x-%012x',
    shiftright(ts, 16),                      -- timestamp (high 32 bits)
    ts & 65535,                              -- timestamp (low 16 bits)
    cast(rand() * 4096 as int),              -- rand_a (12 bits)
    (cast(rand() * 16384 as int) | 32768),   -- rand_b (variant + 14 bits)
    cast(rand() * 281474976710656 as bigint) -- rand_b (last 48 bits)
  )
from (select unix_millis(current_timestamp()) as ts)
