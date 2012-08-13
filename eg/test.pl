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

    if (eq_deeply($got, $expected)) {
        local $Test::Builder::Level = $Test::Builder::Level + 1;
        $builder->ok(1, $msg);
    } else {
        local $Test::Builder::Level = $Test::Builder::Level + 1;
        my $difflet = Data::Difflet->new();
        $builder->ok(0, $msg);
        $builder->diag($difflet->compare($got, $expected));
    }
}

equivalent( { "foo" => [ 1, 2, 3 ] }, { "foo" => [ 4, 2, 3 ] } );

done_testing;
