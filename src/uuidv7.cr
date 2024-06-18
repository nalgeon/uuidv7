require "uuid"

class Uuidv7
  @@rand = Random.new

  @uuid : UUID

  forward_missing_to @uuid

  def initialize
    # random bytes
    value = @@rand.random_bytes(16)

    # current timestamp
    timestamp = Time.utc.to_unix_ms
    timestamp.unsafe_as(StaticArray(UInt8, 8)).reverse!.to_slice[2..].copy_to(value)

    # version and variant
    value[6] = (value[6] & 0x0F) | 0x70
    value[8] = (value[8] & 0x0F) | 0x80

    @uuid = UUID.new(value)
  end
end

puts Uuidv7.new.hexstring
