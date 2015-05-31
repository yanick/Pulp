package Pulp::Role::Action::Typist;

use strict;
use warnings;

use Future;

use Moose::Role;
with 'Pulp::Role::Action';

use Log::Contextual qw( :log :dlog );

requires 'insert';

sub press {
    my( $self, @futures ) = @_;

    return @futures, map { Future->done($_) } $self->insert;
}

1;



