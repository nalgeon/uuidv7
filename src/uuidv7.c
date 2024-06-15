#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

int uuidv7(uint8_t* value) {
    // random bytes
    int err = getentropy(value, 16);
    if (err != EXIT_SUCCESS) {
        return EXIT_FAILURE;
    }

    // current timestamp in ms
    struct timespec ts;
    int ok = timespec_get(&ts, TIME_UTC);
    if (ok == 0) {
        return EXIT_FAILURE;
    }
    uint64_t timestamp = (uint64_t)ts.tv_sec * 1000 + ts.tv_nsec / 1000000;

    // timestamp
    value[0] = (timestamp >> 40) & 0xFF;
    value[1] = (timestamp >> 32) & 0xFF;
    value[2] = (timestamp >> 24) & 0xFF;
    value[3] = (timestamp >> 16) & 0xFF;
    value[4] = (timestamp >> 8) & 0xFF;
    value[5] = timestamp & 0xFF;

    // version and variant
    value[6] = (value[6] & 0x0F) | 0x70;
    value[8] = (value[8] & 0x3F) | 0x80;

    return EXIT_SUCCESS;
}

int main() {
    uint8_t uuid_val[16];
    uuidv7(uuid_val);
    for (size_t i = 0; i < 16; i++) {
        printf("%02x", uuid_val[i]);
    }
    printf("\n");
}
