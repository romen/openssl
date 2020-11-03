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

setup("test_fuzz_asn1_8");

my @fuzzers = ();
@fuzzers = split /\s+/, $ENV{FUZZ_TESTS} if $ENV{FUZZ_TESTS};

plan skip_all => "Run only test_fuzz when the env variable FUZZ_TESTS is set"
    if @fuzzers;

@fuzzers = ('asn1/8');

plan tests => scalar @fuzzers + 1; # one more due to below require_ok(...)

require_ok(srctop_file('test','recipes','fuzz.pl'));

&fuzz_tests(@fuzzers);
