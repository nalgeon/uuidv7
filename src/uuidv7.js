function uuidv7() {
    const buffer = new ArrayBuffer(16);
    const view = new DataView(buffer);
    const value = new Uint8Array(buffer);

    // current timestamp in ms
    const timestamp = Date.now();
    view.setUint16(0, Math.floor(timestamp / 2**32));
    view.setUint32(2, timestamp);

    // random bytes
    crypto.getRandomValues(value.subarray(6));

    // version and variant
    value[6] = (value[6] & 0x0f) | 0x70;
    value[8] = (value[8] & 0x3f) | 0x80;

    return value;
}

const uuidVal = uuidv7();
const uuidStr = Array.from(uuidVal)
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
console.log(uuidStr);
