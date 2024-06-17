use Bytes::Random::Secure qw(random_bytes);
use Time::HiRes qw(time);

sub uuidv7 {
  # random bytes
  my $value = random_bytes(16);

  # current timestamp in ms
  my $timestamp = int(time*1000);

  # timestamp
  $value[0] = ($timestamp >> 40) & 0xFF;
  $value[1] = ($timestamp >> 32) & 0xFF;
  $value[2] = ($timestamp >> 24) & 0xFF;
  $value[3] = ($timestamp >> 16) & 0xFF;
  $value[4] = ($timestamp >> 8) & 0xFF;
  $value[5] = $timestamp & 0xFF;

  # version and variant
  $value[6] = ($value[6] & 0x0F) | 0x70;
  $value[8] = ($value[8] & 0x3F) | 0x80;

  $value;
}

if (__FILE__ eq $0) {
  my $uuid_val = uuidv7;
  print unpack('H*', $uuid_val)."\n";
}
