from pyspark import sql
from pyspark.sql import functions as f


def generate_uuidv7(timestamp_column: str | None = None) -> sql.Column:
    """
    Generates a proper UUIDv7 using PySpark functions

    Optional Parameter:
        timestamp_column: The column to use for the timestamp
        If not provided, the current timestamp will be used

    Returns:
        sql.Column: A UUIDv7 string
    """
    if timestamp_column:
        timestamp_hex = f.lpad(
            f.lower(f.hex(f.unix_millis(timestamp_column.cast("timestamp")))), 12, "0"
        )
    else:
        timestamp_hex = f.lpad(
            f.lower(f.hex(f.unix_millis(f.current_timestamp()))), 12, "0"
        )

    # Build UUID7 string
    uuid_str = f.concat(
        # First 8 chars: high 32 bits of timestamp
        f.substring(timestamp_hex, 1, 8),
        f.lit("-"),
        # Next 4 chars: low 16 bits of timestamp
        f.substring(timestamp_hex, 9, 4),
        f.lit("-"),
        # Next 4 chars: version (7) + 12 bits of rand_a
        f.concat(
            f.lit("7"), f.lpad(f.lower(f.hex((f.rand() * 4096).cast("int"))), 3, "0")
        ),
        f.lit("-"),
        # Next 4 chars: variant (10) + 14 bits random
        f.lpad(f.lower(f.hex((f.rand() * 16384 + 32768).cast("int"))), 4, "0"),
        f.lit("-"),
        # Last 12 chars: 48 bits of random data
        f.lpad(f.lower(f.hex((f.rand() * 281474976710656).cast("bigint"))), 12, "0"),
    )
    return uuid_str
