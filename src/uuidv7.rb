require 'securerandom'
require 'time'

def uuidv7
  # random bytes
  value = SecureRandom.random_bytes(16).bytes

  # current timestamp in ms
  timestamp = (Time.now.to_f * 1000).to_i

  # timestamp
  value[0] = (timestamp >> 40) & 0xFF
  value[1] = (timestamp >> 32) & 0xFF
  value[2] = (timestamp >> 24) & 0xFF
  value[3] = (timestamp >> 16) & 0xFF
  value[4] = (timestamp >> 8) & 0xFF
  value[5] = timestamp & 0xFF

  # version and variant
  value[6] = (value[6] & 0x0F) | 0x70
  value[8] = (value[8] & 0x3F) | 0x80

  value
end

if __FILE__ == $0
  uuid_val = uuidv7
  puts uuid_val.pack('C*').unpack1('H*')
end
