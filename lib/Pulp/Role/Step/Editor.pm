package Pulp::Role::Step::Editor;

use strict;
use warnings;

use Moose::Role;
with 'Pulp::Role::Step';

requires 'edit';

sub press {
    my( $self, @folios ) = @_;

    return map { $self->edit( $_->copy ) } @folios;
}

1;





