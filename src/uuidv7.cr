# UUIDv7 implementation in Crystal.
# License: Public Domain.

require "uuid"

struct UUIDv7
  def self.generate : UUID
    value = Random::Secure.random_bytes(16)
    ts = Time.utc.to_unix_ms

    # timestamp
    value[0] = (ts >> 40).to_u8!
    value[1] = (ts >> 32).to_u8!
    value[2] = (ts >> 24).to_u8!
    value[3] = (ts >> 16).to_u8!
    value[4] = (ts >> 8).to_u8!
    value[5] = ts.to_u8!

    # version and variant
    value[6] = (value[6] & 0x0f) | 0x70
    value[8] = (value[8] & 0x3f) | 0x80

    UUID.new(value)
  end
end

puts UUIDv7.generate
