require "uuid"

class Uuidv7
  @@rand = Random.new

  @uuid : UUID

  forward_missing_to @uuid

  def initialize
    # random bytes
    value = @@rand.random_bytes(16)

    # current timestamp in ms
    timestamp = Time.utc.to_unix_ms

    # timestamp
    timestamp_bytes = StaticArray(UInt8, 8).new(0).to_slice
    IO::ByteFormat::BigEndian.encode(timestamp, timestamp_bytes)
    timestamp_bytes[2..].copy_to(value)

    # version and variant
    value[6] = (value[6] & 0x0F) | 0x70
    value[8] = (value[8] & 0x0F) | 0x80

    @uuid = UUID.new(value)
  end
end

puts Uuidv7.new.hexstring
