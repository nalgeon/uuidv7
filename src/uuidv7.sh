#!/bin/sh

uuidv7() {
    # current timestamp in ms. POSIX date does not support %3N.
    timestamp=$(date +%s)000
    timestamp_hi=$(( timestamp >> 16 ))
    timestamp_lo=$(( timestamp & 0xFF ))

    # 16 random bits (12 will be used)
    rand_a=0x$(head -c 2 /dev/urandom|xxd -ps)
    # ver is 0x7
    ver_rand_a=$(( 0x7000 | ( 0xFFF & rand_a ) ))

    # 16 random bits (14 will be used)
    rand_b_1=0x$(head -c 2 /dev/urandom|xxd -ps)
    # var is 0b10
    var_rand_b=$(( 0x8000 | ( 0x3FFF & rand_b_1 ) ))
    # remaining 48 bits of rand b
    rand_b_2=$(head -c 6 /dev/urandom|xxd -ps)

    printf "%08x-%04x-%04x-%4x-%s" "$timestamp_hi" "$timestamp_lo" "$ver_rand_a" "$var_rand_b" "$rand_b_2"
}

for byte in $(uuidv7); do
    printf "%s" "$byte"
done
echo
