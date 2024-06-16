use std::error::Error;
use std::time::{SystemTime, UNIX_EPOCH};

fn uuidv7() -> Result<[u8; 16], Box<dyn Error>> {
    // random bytes
    let mut value = [0u8; 16];
    getrandom::getrandom(&mut value)?;

    // current timestamp in ms
    let timestamp = match SystemTime::now().duration_since(UNIX_EPOCH) {
        Ok(duration) => duration.as_millis() as u64,
        Err(_) => return Err(Box::from("Failed to get system time")),
    };

    // timestamp
    value[0] = (timestamp >> 40) as u8;
    value[1] = (timestamp >> 32) as u8;
    value[2] = (timestamp >> 24) as u8;
    value[3] = (timestamp >> 16) as u8;
    value[4] = (timestamp >> 8) as u8;
    value[5] = timestamp as u8;

    // version and variant
    value[6] = (value[6] & 0x0F) | 0x70;
    value[8] = (value[8] & 0x3F) | 0x80;

    Ok(value)
}

fn main() {
    match uuidv7() {
        Ok(uuid_val) => {
            for byte in &uuid_val {
                print!("{:02x}", byte);
            }
            println!();
        }
        Err(e) => eprintln!("Error: {}", e),
    }
}
