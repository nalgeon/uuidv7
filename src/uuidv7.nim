import std/[times, strutils, sequtils, sysrand]

proc uuidv7(): seq[byte] =
  # random bytes
  result = urandom(16)

  # current timestamp in ms
  let timestamp = epochTime().uint64 * 1000

  # timestamp
  result[0] = (timestamp shr 40).byte and 0xFF
  result[1] = (timestamp shr 32).byte and 0xFF
  result[2] = (timestamp shr 24).byte and 0xFF
  result[3] = (timestamp shr 16).byte and 0xFF
  result[4] = (timestamp shr 8).byte and 0xFF
  result[5] = timestamp.byte and 0xFF

  # version and variant
  result[6] = (result[6] and 0x0F) or 0x70
  result[8] = (result[8] and 0x3F) or 0x80

var uuidVal = uuidv7()
echo uuidVal.mapIt(it.toHex(2)).join()
