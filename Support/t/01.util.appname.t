#!/usr/bin/perl -w

use strict;
use Test::More tests => 1;
use Catalyst::TMBundle qw(:test :cmds);

$ENV{TM_PROJECT_DIRECTORY} = 't/test-project';

is(_get_app_name, "MyLine");

#is(get_input('Test?', 'Please respond with OK'), "OK", "yay, get input works");


