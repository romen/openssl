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

my @most_fuzzers = (
    'asn1parse', 'bignum', 'bndiv', 'conf', 'crl', 'x509'
);
push @most_fuzzers, 'cmp' if !disabled("cmp");
push @most_fuzzers, 'cms' if !disabled("cms");
push @most_fuzzers, 'ct' if !disabled("ct");

my @all_fuzzers = (
    # those commented here as very slow were moved to separate runs:
    # to run all of them sequentially at once one could do
    'asn1/*', # very slow -> 99-test_fuzz_asn1_[0-9a-f].t
              # they are split in 16 subsets, to run all of them
              # sequentially at once, one could do:
              #  `make FUZZ_TESTS='asn1/*' TESTS='test_fuzz' test`
    'client', # very slow -> 99-test_fuzz_client.t
    'server'  # very slow -> 99-test_fuzz_server.t
);
push @all_fuzzers, @most_fuzzers;


my @fuzzers = ();
# we can select which fuzz tests to run using the FUZZ_TESTS env
# variable as a space separated list
@fuzzers = split /\s+/, $ENV{FUZZ_TESTS} if $ENV{FUZZ_TESTS};

# if $ENV{FUZZ_TESTS} includes 'all', we use the @all_fuzzers list, to
# sequentially run all the known fuzz tests.
# This allows to do, for example:
#   `make FUZZ_TESTS='all' TESTS='test_fuzz' test`
@fuzzers = @all_fuzzers if $ENV{FUZZ_TESTS} =~ /\ball\b/;

# We default to the fuzzers that don't run for a very long time if
# FUZZ_TESTS is not set: the very slow fuzz tests are likely run by
# their dedicated recipes.
@fuzzers = @most_fuzzers if !@fuzzers;

plan tests => scalar @fuzzers + 1; # one more due to below require_ok(...)

require_ok(srctop_file('test','recipes','fuzz.pl'));

&fuzz_tests(@fuzzers);
