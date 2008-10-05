#!/usr/bin/perl -w

use strict;
use Test::More tests => 1;
use Catalyst::TMBundle::XML qw/parse/;


my $xml = <<"";
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>view_string</key>
	<string>my</string>
</dict>
</plist>

my $doc = parse($xml);
ok($doc);
