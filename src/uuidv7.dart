import 'dart:math';
import 'dart:typed_data';

Uint8List uuidv7() {
  // random bytes
  final rng = Random.secure();
  final value = Uint8List(16);
  for (int i = 0; i < 16; i++) {
    value[i] = rng.nextInt(256);
  }

  // current timestamp in ms
  final timestamp = DateTime.now().millisecondsSinceEpoch;

  // timestamp
  value[0] = (timestamp ~/ pow(2, 40)) & 0xFF;
  value[1] = (timestamp ~/ pow(2, 32)) & 0xFF;
  value[2] = (timestamp ~/ pow(2, 24)) & 0xFF;
  value[3] = (timestamp ~/ pow(2, 16)) & 0xFF;
  value[4] = (timestamp ~/ pow(2, 8)) & 0xFF;
  value[5] = timestamp & 0xFF;

  // version and variant
  value[6] = (value[6] & 0x0F) | 0x70;
  value[8] = (value[8] & 0x3F) | 0x80;

  return value;
}

void main() {
  final uuidVal = uuidv7();
  print(uuidVal.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join());
}
