#!perl

# vim: ts=4 sts=4 sw=4 et: syntax=perl
#
# Copyright (c) 2018-2022 Sven Kirmess
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

use 5.006;
use strict;
use warnings;

use Test::Fatal;
use Test::More 0.88;

use Perl::Critic::MergeProfile;

main();

sub main {

    my $class = 'Perl::Critic::MergeProfile';

    note('write string');
    {
        my $obj = $class->new();

        my $input_string    = "global_1=global_val1\n[Policy1]\npolicy_1=policy_val1";
        my $expected_string = "global_1=global_val1\n\n[Policy1]\npolicy_1=policy_val1\n";
        $obj->read_string($input_string);

        is_deeply( $obj->write_string(), $expected_string, 'write_string returns the expected policy config' );

        #
        $obj->read_string('global_1=global_val1b');
        $expected_string = "global_1=global_val1b\n\n[Policy1]\npolicy_1=policy_val1\n";

        is_deeply( $obj->write_string(), $expected_string, 'write_string returns the expected policy config (two policies merged)' );
    }

    note('not initialized');
    {
        my $obj = $class->new();
        like( exception { $obj->write_string() }, qr{No policy exists to write}, 'write_string throws an error (not initialized)' );

        $obj->{_config} = 'hello world';
        like( exception { $obj->write_string() }, qr{No policy exists to write}, 'write_string throws an error (not an object)' );

        $obj->{_config} = bless {}, 'Local::HelloWorld';
        like( exception { $obj->write_string() }, qr{No policy exists to write}, 'write_string throws an error (wrong object)' );
    }

    note('Config::Tiny error');
    {
        my $obj = $class->new();

        my $input_string = "global_1=global_val1\n[Policy1]\npolicy_1=policy_val1";
        $obj->read_string($input_string);

        ${ $obj->{_config} }{"Invalid\nsection\nname"} = {};

        like( exception { $obj->write_string() }, qr{.*}, 'write_string throws an error if write_string of Config::Tiny fails' );
    }

    #
    done_testing();

    exit 0;
}
