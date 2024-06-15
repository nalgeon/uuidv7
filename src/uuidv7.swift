import Foundation

func uuidv7() -> [UInt8] {
    // random bytes
    var value = (0..<16).map { _ in UInt8.random(in: 0...255) }

    // current timestamp in ms
    let timestamp = Int(Date().timeIntervalSince1970 * 1000)

    // timestamp
    value[0] = UInt8((timestamp >> 40) & 0xFF)
    value[1] = UInt8((timestamp >> 32) & 0xFF)
    value[2] = UInt8((timestamp >> 24) & 0xFF)
    value[3] = UInt8((timestamp >> 16) & 0xFF)
    value[4] = UInt8((timestamp >> 8) & 0xFF)
    value[5] = UInt8(timestamp & 0xFF)

    // version and variant
    value[6] = (value[6] & 0x0F) | 0x70
    value[8] = (value[8] & 0x3F) | 0x80

    return value
}

let uuidVal = uuidv7()
print(uuidVal.map { String(format: "%02x", $0) }.joined())
