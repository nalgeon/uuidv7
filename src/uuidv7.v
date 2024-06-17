import rand
import time

fn uuidv7() ![]u8 {
	mut value := rand.bytes(16)!

	// current timestamp in ms
	timestamp := u64(time.now().unix_milli())

	// timestamp
	value[0] = u8((timestamp >> 40) & 0xFF)
	value[1] = u8((timestamp >> 32) & 0xFF)
	value[2] = u8((timestamp >> 24) & 0xFF)
	value[3] = u8((timestamp >> 16) & 0xFF)
	value[4] = u8((timestamp >> 8) & 0xFF)
	value[5] = u8(timestamp & 0xFF)

	// version and variant
	value[6] = (value[6] & 0x0F) | 0x70
	value[8] = (value[8] & 0x3F) | 0x80

	return value
}

fn main() {
	uuid_val := uuidv7()!

	for _, val in uuid_val {
		print('${val:02x}')
	}
	println('')
}
