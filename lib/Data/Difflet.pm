package Data::Difflet;
use strict;
use warnings;
use 5.008008;
our $VERSION = '0.01';
use Term::ANSIColor;
use Data::Dumper;

our $LEVEL;
our $BUFFER;

sub new {
    my $class = shift;
    bless {
        inserted_color => 'green',
        deleted_color => 'red',
        updated_color => 'blue',
        comment_color => 'cyan',
        indent => 2,
    }, $class;
}

sub _($) { die "Do not call directly"; }

sub ddf {
    my $self = shift;
    @_==1 or die;

    local $Data::Dumper::Terse = 1;
    local $Data::Dumper::Indent = 0;
    Dumper(@_);
}

sub compare {
    my $self = shift;
    local $LEVEL = 0;
    local $BUFFER = '';
    no warnings 'redefine';
    local *_ = sub($) { $self->ddf(@_) };
    $self->_compare(@_);
    return $BUFFER;
}

# TODO: recursion detection
sub _compare {
    my ($self, $a, $b) = @_;
    if (ref $a eq 'HASH') { # dump hash
        if (ref $b eq 'HASH') {
            $self->_print("{\n");
            {
                local $LEVEL = $LEVEL + 1;
                for my $key (sort keys %$a) {
                    if (exists $b->{$key}) {
                        if ($self->ddf($b->{$key}) eq $self->ddf($a->{$key})) {
                            $self->_print("%s => %s,\n", $self->ddf($key), $self->ddf($a->{$key}));
                        } else {
                            if (ref($a->{$key}) or ref($b->{$key})) {
                                $self->_print("%s => ", _($key));
                                local $LEVEL = $LEVEL + 1;
                                $self->_compare($a->{$key}, $b->{$key});
                                $self->_print(",\n");
                            } else {
                                $self->_updated("%s => %s,", _($key), _($a->{$key}));
                                $self->_comment(" # != %s,\n", _($b->{$key}));
                            }
                        }
                    } else {
                        $self->_inserted("%s => %s,\n", $self->ddf($key), $self->ddf($a->{$key}));
                    }
                }
                for my $key (sort keys %$b) {
                    next if exists $a->{$key};
                    $self->_deleted("%s => %s,\n", $self->ddf($key), $self->ddf($b->{$key}));
                }
            }
            $self->_print("}\n");
            return;
        } else {
            $self->_inserted("%s\n", $self->ddf($a));
            $self->_deleted("%s\n",  $self->ddf($b));
        }
    } elsif (ref $a eq 'ARRAY') {
        if (ref $b eq 'ARRAY') {
            $self->_print("[\n");
            {
                local $LEVEL = $LEVEL + 1;
                my $alen = 0+@$a;
                my $blen = 0+@$b;
                my $i = 0;
                while (1) {
                    if ($i<$alen && $i<$blen) { # both
                        if (_($a->[$i]) eq _($b->[$i])) {
                            $self->_print("%s,\n", _($a->[$i]));
                        } else {
                            if (ref($a->[$i]) or ref($b->[$i])) {
                                local $LEVEL = $LEVEL + 1;
                                $self->_compare($a->[$i], $b->[$i]);
                            } else {
                                $self->_updated("%s,", $a->[$i]);
                                $self->_comment(" # != %s\n", $b->[$i]);
                            }
                        }
                    } elsif ($i<$alen) {
                        $self->_inserted("%s,\n", _ $a->[$i]);
                    } elsif ($i<$blen) {
                        $self->_deleted("%s,\n", _ $b->[$i]);
                    } else {
                        last;
                    }
                    ++$i;
                }
            }
            $self->_print("]\n");
        } else {
            $self->_inserted("%s\n", $self->ddf($a));
            $self->_deleted("%s\n",  $self->ddf($b));
        }
    } else {
        if ($self->ddf($a) eq $self->ddf($b)) {
            $self->_print("%s\n", $self->ddf($a));
        } else {
            $self->_inserted("%s\n", $self->ddf($a));
            $self->_deleted("%s\n", $self->ddf($b));
        }
    }
}

sub _print {
    my ($self, @args) = @_;
    $BUFFER .= ' 'x($LEVEL*$self->{indent});
    $BUFFER .= sprintf colored(['reset'], shift @args), @args;
}

sub _inserted {
    my ($self, @args) = @_;
    $BUFFER .= ' 'x($LEVEL*$self->{indent});
    $BUFFER .= sprintf colored([$self->{"inserted_color"}], shift @args), @args;
}

sub _updated {
    my ($self, @args) = @_;
    $BUFFER .= ' 'x($LEVEL*$self->{indent});
    $BUFFER .= sprintf colored([$self->{"updated_color"}], shift @args), @args;
}

sub _deleted {
    my ($self, @args) = @_;
    $BUFFER .= ' 'x($LEVEL*$self->{indent});
    $BUFFER .= sprintf colored([$self->{"deleted_color"}], shift @args), @args;
}

sub _comment {
    my ($self, @args) = @_;
    $BUFFER .= ' 'x($LEVEL*$self->{indent});
    $BUFFER .= sprintf colored([$self->{"comment_color"}], shift @args), @args;
}

1;
__END__

=encoding utf8

=head1 NAME

Data::Difflet - Ultra special pretty cute diff generator Mark II

=head1 SYNOPSIS

    use Data::Difflet;

    my $difflet = Data::Difflet->new();
    $difflet->compare(
        {
            a => 2,
            c => 5,
        },
        {
            a => 3,
            b => 4,
        }
    );

=head1 DESCRIPTION

Data::Difflet is colorful diff generator for Perl5!

See the following image!

=begin html

<img src="http://gyazo.64p.org/image/a82cb1898b53d51e45e49b21667aec85.png">

=end html

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF@ GMAIL COME<gt>

=head1 SEE ALSO

This module is inspired from node.js library named difflet.
L<git://github.com/substack/difflet.git>

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
