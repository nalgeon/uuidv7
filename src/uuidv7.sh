#!/bin/sh

uuidv7() {
    # random bytes
    rand_bytes=$(dd if=/dev/urandom bs=1 count=16 2>/dev/null | xxd -p)

    # current timestamp in ms
    timestamp=$(date +%s%3N)
    t_hex=$(printf "%012x" $timestamp)

    # timestamp
    value[0]=${t_hex:0:2}
    value[1]=${t_hex:2:2}
    value[2]=${t_hex:4:2}
    value[3]=${t_hex:6:2}
    value[4]=${t_hex:8:2}
    value[5]=${t_hex:10:2}

    # version / rand_a
    value[6]=$(printf "%02x" $((0x70 | (0x${rand_bytes:12:2} & 0x0F))))
    value[7]=${rand_bytes:14:2}

    # variant / rand_b
    value[8]=$(printf "%02x" $((0x80 | (0x${rand_bytes:16:2} & 0x3F))))

    # rand_b
    value[9]=${rand_bytes:18:2}
    value[10]=${rand_bytes:20:2}
    value[11]=${rand_bytes:22:2}
    value[12]=${rand_bytes:24:2}
    value[13]=${rand_bytes:26:2}
    value[14]=${rand_bytes:28:2}
    value[15]=${rand_bytes:30:2}

    echo "${value[@]}"
}

for byte in $(uuidv7); do
    printf "%s" "$byte"
done
echo
