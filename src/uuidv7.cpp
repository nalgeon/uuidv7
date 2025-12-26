// UUIDv7 implementation in C++.
// License: Public Domain.

#include <algorithm>
#include <array>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <random>

std::array<uint8_t, 16> uuidv7() {
    static thread_local std::random_device rd;
    std::array<uint8_t, 16> value;

    // random bytes
    uint32_t randb[4] = {rd(), rd(), rd(), rd()};
    std::memcpy(value.data(), randb, sizeof(randb));

    // current timestamp in ms
    auto now = std::chrono::system_clock::now();
    auto ts = std::chrono::duration_cast<std::chrono::milliseconds>(now.time_since_epoch()).count();

    // timestamp
    value[0] = static_cast<uint8_t>(ts >> 40);
    value[1] = static_cast<uint8_t>(ts >> 32);
    value[2] = static_cast<uint8_t>(ts >> 24);
    value[3] = static_cast<uint8_t>(ts >> 16);
    value[4] = static_cast<uint8_t>(ts >> 8);
    value[5] = static_cast<uint8_t>(ts);

    // version and variant
    value[6] = (value[6] & 0x0F) | 0x70;
    value[8] = (value[8] & 0x3F) | 0x80;

    return value;
}

int main() {
    auto uuid_val = uuidv7();
    for (const auto& byte : uuid_val) {
        printf("%02x", byte);
    }
    printf("\n");
    return 0;
}
