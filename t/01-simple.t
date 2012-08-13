use strict;
use warnings;
use utf8;
use Test::More 0.96;

# Yes, this is silly.
# please write correct test case and pull-req for me!
use Data::Difflet;

my $difflet = Data::Difflet->new();

$difflet->compare(+{
    1 => 2,
    2 => 3,
    foo => 'bar',
}, {1 => 2, 2 => 4, 3 => 1});

$difflet->compare(+{
    1 => 2,
    2 => 3,
    foo => 'bar',
}, [1,2,3]);

$difflet->compare(+[
    4,
    2,
    3,
    8
], [1,2,3]);

$difflet->compare(+[1], {});
$difflet->compare('a', 'b');
$difflet->compare('a', 'a');

$difflet->compare(
    +[
        {
            1 => 2,
            2 => 3,
        },
    ],
    [ { 2 => 4, 3 => 5 } ]
);

$difflet->compare(
    +[
        {
            1   => 2,
            2   => 3,
            foo => [ 3, 4, 7, 8 ]
        },
    ],
    [ { 2 => 4, 3 => 5, foo => [ 3, 4, 5 ] } ]
);

ok 1;

done_testing;

