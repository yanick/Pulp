package Pulp::Role::Action::Edit;

use strict;
use warnings;

use Moose::Role;
with 'Pulp::Role::Action';

requires 'edit';

sub plan_action {
    my( $self, @futures ) = @_;

    return map { my $f1 = $_; $f1->then( sub{
        my $folio = shift or return $f1;

        warn "$self ", $folio->filename;

        Future->done( $self->edit($folio->copy) );
    } )
    } @futures;
}

1;





