#!/usr/bin/perl -w

use strict;
use Test::More tests => 3;
use Catalyst::TMBundle::PList qw/parse/;

use Data::Dump qw/dump/;


my $xml = <<"";
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Catalyst_create_view_string</key>
	<string>My View</string>
	<key>result</key>
	<dict>
		<key>returnArgument</key>
		<string>My View</string>
	</dict>
	<key>view_string</key>
	<string>my</string>
</dict>
</plist>

my $plist = parse($xml);
ok($plist);

is($plist->{dict}->{view_string}, "my", "plist-parser working");
is($plist->{dict}->{result}->{returnArgument}, "My View", "recursive parsing works!");
