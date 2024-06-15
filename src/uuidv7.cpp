#include <array>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <random>

std::array<uint8_t, 16> uuidv7() {
    // random bytes
    std::random_device rd;
    std::array<uint8_t, 16> random_bytes;
    std::generate(random_bytes.begin(), random_bytes.end(), std::ref(rd));
    std::array<uint8_t, 16> value;
    std::copy(random_bytes.begin(), random_bytes.end(), value.begin());

    // current timestamp in ms
    auto now = std::chrono::system_clock::now();
    auto millis = std::chrono::duration_cast<std::chrono::milliseconds>(
        now.time_since_epoch()
    ).count();

    // timestamp
    value[0] = (millis >> 40) & 0xFF;
    value[1] = (millis >> 32) & 0xFF;
    value[2] = (millis >> 24) & 0xFF;
    value[3] = (millis >> 16) & 0xFF;
    value[4] = (millis >> 8) & 0xFF;
    value[5] = millis & 0xFF;

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
