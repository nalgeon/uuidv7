import std/[times, strutils, sequtils, random]

randomize()

proc uuidv7(): seq[byte] =
  # Random bytes
  result = 16.newSeqWith(256.rand().byte)

  # Get Timestamp in ms
  let timestamp = epochTime().uint64 * 1000

  # Timestamp
  result[0] = (timestamp shr 40).byte and 0xFF
  result[1] = (timestamp shr 32).byte and 0xFF
  result[2] = (timestamp shr 24).byte and 0xFF
  result[3] = (timestamp shr 16).byte and 0xFF
  result[4] = (timestamp shr 8).byte and 0xFF
  result[5] = timestamp.byte and 0xFF

  # Version and var
  result[6] = (result[6] and 0x0F) or 0x70
  result[8] = (result[8] and 0x3F) or 0x80

# Generates the initial UUID string without dashes
var uuid = uuidv7().mapIt(it.toHex(2)).join()

# Add dashes at the specified indices.
uuid.insert("-", 8)
uuid.insert("-", 13)
uuid.insert("-", 18)
uuid.insert("-", 23)

# Print the UUID
echo uuid
