# NAME

Data::Difflet - Ultra special pretty cute diff generator Mark II

# SYNOPSIS

    use Data::Difflet;

    my $difflet = Data::Difflet->new();
    print $difflet->compare(
        {
            a => 2,
            c => 5,
        },
        {
            a => 3,
            b => 4,
        }
    );

# DESCRIPTION

__THIS MODULE IS IN ITS BETA QUALITY. THE API MAY CHANGE IN THE FUTURE__

Data::Difflet is colorful diff generator for Perl5!

See the following image!

<img src="http://gyazo.64p.org/image/a82cb1898b53d51e45e49b21667aec85.png">

# METHODS

- my $difflet = Data::Difflet->new();

    Create new instance of Data::Difflet object.

- $difflet->compare($a, $b);

    Compare the two data and get a colorized strings.

# AUTHOR

Tokuhiro Matsuno <tokuhirom AAJKLFJEF@ GMAIL COM>

# SEE ALSO

This module is inspired from node.js library named difflet.
[git://github.com/substack/difflet.git](git://github.com/substack/difflet.git)

# LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
