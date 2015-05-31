package Pulp::Role::Action::Editor;

use strict;
use warnings;

use Moose::Role;
with 'Pulp::Role::Action';

requires 'edit';

sub press {
    my( $self, @folios ) = @_;

    return map { $self->edit( $_->copy ) } @folios;
}

1;





