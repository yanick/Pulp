package Pulp::Command;

use strict;
use warnings;

use MooseX::App::Simple;

use File::Serialize;

parameter pulp_file => (
    is => 'ro',
    isa => 'Str',
    documentation => 'pulp script to load',
    required => 1,
);

parameter targets => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    documentation => 'pressing targets',
    required => 0,
    default => sub { [] },
);

option config => (
    is => 'ro',
    isa => 'Str',
    documentation => 'arguments for the Pulp object',
    predicate => 'has_config',
);

sub run {
    my $self = shift;

    my $class  = do $self->pulp_file or die $@;

    my $args = ( $self->has_config && deserialize_file $self->config ) || {};

    my $pulp = $class->new(%$args);

    $pulp->press($_) for @{$self->targets};
}

1;

