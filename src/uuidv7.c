// UUIDv7 implementation in C (POSIX).
// License: Public Domain.

#include <stdint.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>

int uuidv7(uint8_t value[16]) {
    // current timestamp in ms
    struct timespec ts;
    if (clock_gettime(CLOCK_REALTIME, &ts) != 0) {
        return -1;
    }
    uint64_t ms = (uint64_t)ts.tv_sec * 1000 + (ts.tv_nsec / 1000000);

    // timestamp (48 bits)
    value[0] = (uint8_t)(ms >> 40);
    value[1] = (uint8_t)(ms >> 32);
    value[2] = (uint8_t)(ms >> 24);
    value[3] = (uint8_t)(ms >> 16);
    value[4] = (uint8_t)(ms >> 8);
    value[5] = (uint8_t)ms;

    // 80 random bits
    if (getentropy(value + 6, 10) != 0) {
        return -1;
    }

    // version and variant
    value[6] = (value[6] & 0x0F) | 0x70;
    value[8] = (value[8] & 0x3F) | 0x80;

    return 0;
}

int main() {
    uint8_t uuid_val[16];
    uuidv7(uuid_val);
    for (size_t i = 0; i < 16; i++) {
        printf("%02x", uuid_val[i]);
    }
    printf("\n");
}
