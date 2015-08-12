package err;

use strict;
use Data::Dumper;
use lib '/srv/restful/lib';

our $ERROR;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    my %c = @_;
    map { $self->{lc($_)} = $c{$_} } keys %c;
    return $self;
}

sub set {
    my $self = shift;
    $self->{errstr} = $ERROR = shift;
    return 1;
}

sub get {
    my $self = shift;
    return $ERROR;
}

sub errstr {
    my $self = shift;
    return $ERROR;
}

sub debug {
    my $self = shift;
    return $self->{debug};
}

sub clean {
    my $self = shift;
    undef $ERROR;
}

1;
