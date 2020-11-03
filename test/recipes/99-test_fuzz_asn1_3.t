#!/usr/bin/env perl
# Copyright 2016-2020 The OpenSSL Project Authors. All Rights Reserved.
#
# Licensed under the Apache License 2.0 (the "License").  You may not use
# this file except in compliance with the License.  You can obtain a copy
# in the file LICENSE in the source distribution or at
# https://www.openssl.org/source/license.html

use strict;
use warnings;

use OpenSSL::Test qw/:DEFAULT srctop_file/;
use OpenSSL::Test::Utils;

setup("test_fuzz_asn1_3");

my @fuzzers = ('asn1/3');

plan tests => scalar @fuzzers + 1; # one more due to below require_ok(...)

require_ok(srctop_file('test','recipes','fuzz.pl'));

&fuzz_tests(@fuzzers);
