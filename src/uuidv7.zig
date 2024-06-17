const std = @import("std");

fn uuidv7() [16]u8 {
    // random bytes
    var value: [16]u8 = undefined;
    std.crypto.random.bytes(value[6..]);

    // current timestamp in ms
    const timestamp: u48 = @intCast(std.time.milliTimestamp());

    // timestamp
    std.mem.writeInt(u48, value[0..6], timestamp, .big);

    // version and variant
    value[6] = (value[6] & 0x0F) | 0x70;
    value[8] = (value[8] & 0x3F) | 0x80;

    return value;
}

pub fn main() void {
    const uuid_val = uuidv7();
    std.debug.print("{s}\n", .{std.fmt.bytesToHex(uuid_val, .upper)});
}
