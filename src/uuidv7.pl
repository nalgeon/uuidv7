#!/usr/bin/env perl

use v5.16;
use Time::HiRes;

sub uuidv7 {
	my $type = shift() || "";

	# 16 random bytes (4 * 4)
	my $uuid = "";
	for (my $i = 0; $i < 4; $i++) {
		$uuid .= pack('I', int(rand(2 ** 32)));
	}

	# current timestamp in ms
	my $timestamp = int(Time::HiRes::time() * 1000);

	# timestamp
	substr($uuid, 0, 1, chr(($timestamp >> 40) & 0xFF));
	substr($uuid, 1, 1, chr(($timestamp >> 32) & 0xFF));
	substr($uuid, 2, 1, chr(($timestamp >> 24) & 0xFF));
	substr($uuid, 3, 1, chr(($timestamp >> 16) & 0xFF));
	substr($uuid, 4, 1, chr(($timestamp >>  8) & 0xFF));
	substr($uuid, 5, 1, chr($timestamp         & 0xFF));

	# version and variant
	substr($uuid, 6, 1, chr((ord(substr($uuid, 6, 1)) & 0x0F) | 0x70));
	substr($uuid, 8, 1, chr((ord(substr($uuid, 8, 1)) & 0x3F) | 0x80));

	return $uuid;
}

my $uuid_val = uuidv7('hex');
printf(unpack("H*", $uuid_val));
