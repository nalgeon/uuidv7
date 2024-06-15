<?php
function uuidv7() {
    // random bytes
    $value = random_bytes(16);

    // current timestamp in ms
    $timestamp = intval(microtime(true) * 1000);

    // timestamp
    $value[0] = chr(($timestamp >> 40) & 0xFF);
    $value[1] = chr(($timestamp >> 32) & 0xFF);
    $value[2] = chr(($timestamp >> 24) & 0xFF);
    $value[3] = chr(($timestamp >> 16) & 0xFF);
    $value[4] = chr(($timestamp >> 8) & 0xFF);
    $value[5] = chr($timestamp & 0xFF);

    // version and variant
    $value[6] = chr((ord($value[6]) & 0x0F) | 0x70);
    $value[8] = chr((ord($value[8]) & 0x3F) | 0x80);

    return $value;
}

$uuid_val = uuidv7();
echo bin2hex($uuid_val);
