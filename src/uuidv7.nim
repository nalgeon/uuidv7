import std/[times, strutils, sequtils, random]

randomize()

proc uuidv7(): seq[byte] =
  # random bytes
  result = newSeqWith(16, rand(255).byte)

  # current timestamp in ms
  let timestamp = (epochTime() * 1000).uint64

  # timestamp
  result[0] = (timestamp shr 40).byte
  result[1] = (timestamp shr 32).byte
  result[2] = (timestamp shr 24).byte
  result[3] = (timestamp shr 16).byte
  result[4] = (timestamp shr 8).byte
  result[5] = timestamp.byte

  # version and variant
  result[6] = (result[6] and 0x0F) or 0x70
  result[8] = (result[8] and 0x3F) or 0x80

var uuidVal = uuidv7()
echo uuidVal.mapIt(it.toHex(2)).join()
