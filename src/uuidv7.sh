#!/bin/sh

uuidv7() {
    # current timestamp in ms. POSIX date does not support %3N.
    timestamp=$(date +%s)000
    timestamp_hi=$(( timestamp >> 16 ))
    timestamp_lo=$(( timestamp & 0xFFFF ))

    # 16 random bits (12 will be used)
    rand_a=0x$(LC_ALL=C tr -dc '0-9a-f' < /dev/urandom|head -c4)
    # ver is 0x7
    ver_rand_a=$(( 0x7000 | ( 0xFFF & rand_a ) )) 

    # 16 random bits (14 will be used)
    rand_b_hi=0x$(LC_ALL=C tr -dc '0-9a-f' < /dev/urandom|head -c4)
    # var is 0b10
    var_rand_hi=$(( 0x8000 | ( 0x3FFF & rand_b_hi ) ))
    # remaining 48 bits of rand b
    rand_b_lo=$(LC_ALL=C tr -dc '0-9a-f' < /dev/urandom|head -c12)

    printf "%08x-%04x-%04x-%4x-%s" "$timestamp_hi" "$timestamp_lo" "$ver_rand_a" "$var_rand_hi" "$rand_b_lo"
}

echo $(uuidv7)
