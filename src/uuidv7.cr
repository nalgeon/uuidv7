require "uuid"

class Uuidv7
  @@rand = Random.new

  @uuid : UUID

  forward_missing_to @uuid

  def initialize
    # random bytes
    #
    value = @@rand.random_bytes(16)

    # current timestamp
    #
    timestamp = Time.utc.to_unix_ms

    # timestamp
    #
    value[0] = (timestamp >> 40 & 0xFF).to_u8
    value[1] = (timestamp >> 32 & 0xFF).to_u8
    value[2] = (timestamp >> 24 & 0xFF).to_u8
    value[3] = (timestamp >> 16 & 0xFF).to_u8
    value[4] = (timestamp >> 8 & 0xFF).to_u8
    value[5] = (timestamp & 0xFF).to_u8

    # version and variant
    #
    value[6] = (value[6] & 0x0F) | 0x70
    value[8] = (value[8] & 0x0F) | 0x80

    @uuid = UUID.new(value)
  end
end

puts Uuidv7.new.hexstring
