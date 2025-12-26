# UUIDv7 implementation for PySpark.
# License: Public Domain.

from pyspark import sql
from pyspark.sql import functions as f


def uuidv7(ts_col: str | None = None) -> sql.Column:
    # timestamp in ms
    ts = f.unix_millis(f.col(ts_col) if ts_col else f.current_timestamp())

    # random bits
    r1 = (f.rand() * 0xFFFFFFFF).cast("bigint")  # 32 bits
    r2 = (f.rand() * 0xFFFFFFFF).cast("bigint")  # 32 bits
    r3 = (f.rand() * 0xFFFFFFFFFFFF).cast("bigint")  # 48 bits

    # combine parts
    return f.lower(
        f.format_string(
            "%08x-%04x-%04x-%04x-%012x",
            f.shiftRight(ts, 16),                           # ts high (32 bits)
            ts.bitwiseAND(0xFFFF),                          # ts low (16 bits)
            f.lit(0x7000).bitwiseOR(r1.bitwiseAND(0x0FFF)), # ver + rand_a
            f.lit(0x8000).bitwiseOR(r2.bitwiseAND(0x3FFF)), # var + rand_b_high
            r3.bitwiseAND(0xFFFFFFFFFFFF),                  # rand_b_low (48 bits)
        )
    )
