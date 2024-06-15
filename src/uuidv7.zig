const std = @import("std");

fn uuidv7() [16]u8 {
    // random bytes
    var value: [16]u8 = undefined;
    std.crypto.random.bytes(&value);

    // current timestamp in ms
    const timestamp: u64 = @intCast(std.time.milliTimestamp());

    // timestamp
    value[0] = @intCast((timestamp >> 40) & 0xFF);
    value[1] = @intCast((timestamp >> 32) & 0xFF);
    value[2] = @intCast((timestamp >> 24) & 0xFF);
    value[3] = @intCast((timestamp >> 16) & 0xFF);
    value[4] = @intCast((timestamp >> 8) & 0xFF);
    value[5] = @intCast(timestamp & 0xFF);

    // version and variant
    value[6] = (value[6] & 0x0F) | 0x70;
    value[8] = (value[8] & 0x3F) | 0x80;

    return value;
}

pub fn main() void {
    const uuid_val = uuidv7();
    for (uuid_val) |byte| {
        std.debug.print("{x:0>2}", .{byte});
    }
    std.debug.print("\n", .{});
}
