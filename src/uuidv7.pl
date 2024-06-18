#!/usr/bin/env perl

use v5.16;
use Time::HiRes;

###############################################################################
###############################################################################

printf("Raw   : %s\n", unpack("H*", uuidv7('raw')));
printf("HEX   : %s\n", uuidv7('hex'));
printf("String: %s\n", uuidv7('string'));

###############################################################################
###############################################################################

sub bin2hex {
	return unpack("H*", $_[0]);
}

sub uuid_format {
	my $uuid  = shift();
	my @parts = map { substr $uuid, 0, $_, '' } ( 4, 2, 2, 2, 6 );
	my @hex   = map { bin2hex($_); } @parts;
	my $ret   = join('-', @hex);

	return $ret;
}

sub uuidv7 {
	my $type = shift() || "";

	# Generate 16 random bytes (4 * 4)
	my $uuid = "";
	for (my $i = 0; $i < 4; $i++) {
		$uuid .= pack('I', int(rand(2 ** 32)));
	}

	# current timestamp in ms
	my $timestamp = int(Time::HiRes::time() * 1000);

	# timestamp section
	substr($uuid, 0, 1, chr(($timestamp >> 40) & 0xFF));
	substr($uuid, 1, 1, chr(($timestamp >> 32) & 0xFF));
	substr($uuid, 2, 1, chr(($timestamp >> 24) & 0xFF));
	substr($uuid, 3, 1, chr(($timestamp >> 16) & 0xFF));
	substr($uuid, 4, 1, chr(($timestamp >>  8) & 0xFF));
	substr($uuid, 5, 1, chr($timestamp         & 0xFF));

	# version and variant
	substr($uuid, 6, 1, chr((ord(substr($uuid, 6, 1)) & 0x0F) | 0x70));
	substr($uuid, 8, 1, chr((ord(substr($uuid, 8, 1)) & 0x3F) | 0x80));

	# Hex string with no hypens
	if ($type eq "hex") {
		return bin2hex($uuid);
		# Raw 16 byte string
	} elsif ($type eq "raw") {
		return $uuid;
		# String representation with hypens (default)
	} else {
		return uuid_format($uuid);
	}
}

# vim: tabstop=4 shiftwidth=4 noexpandtab autoindent softtabstop=4
