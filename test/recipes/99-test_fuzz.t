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

setup("test_fuzz");

my @fuzzers = ();
@fuzzers = split /\s+/, $ENV{FUZZ_TESTS} if $ENV{FUZZ_TESTS};

if (!@fuzzers) {
    @fuzzers = (
        # those commented here as very slow were moved to separate runs
        #'asn1', # very slow -> 99-test_fuzz_asn1.t
        'asn1parse', 'bignum', 'bndiv', 'conf','crl',
        #'client', # very slow -> 99-test_fuzz_client.t
        #'server', # very slow -> 99-test_fuzz_server.t
        'x509'
        );
    push @fuzzers, 'cmp' if !disabled("cmp");
    push @fuzzers, 'cms' if !disabled("cms");
    push @fuzzers, 'ct' if !disabled("ct");
}

plan tests => scalar @fuzzers + 1; # one more due to below require_ok(...)

require_ok(srctop_file('test','recipes','fuzz.pl'));

&fuzz_tests(@fuzzers);
