#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use 5.010000;
use autodie;

use Test::More;
use Test::Deep;
use Data::Difflet;

sub equivalent {
    my ($got, $expected, $msg) = @_;
    my $builder = Test::More->builder;

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    if (-t *STDOUT) {
        if (eq_deeply($got, $expected)) {
            $builder->ok(1, $msg);
        } else {
            my $difflet = Data::Difflet->new();
            $builder->ok(0, $msg);
            $builder->diag($difflet->compare($got, $expected));
        }
    } else {
        is_deeply($got, $expected, $msg);
    }
}

equivalent( { "foo" => [ 1, 2, 3 ] }, { "foo" => [ 4, 2, 3 ] } );

done_testing;
