package Pulp::Role::Action::Injector;

use strict;
use warnings;

use Future;

use Moose::Role;
with 'Pulp::Role::Action';

requires 'insert';

sub plan_action {
    my( $self, @futures ) = @_;

    return @futures, map {
        warn "inserting ", $_->filename;
        Future->done($_);
    } $self->insert;
}

1;



