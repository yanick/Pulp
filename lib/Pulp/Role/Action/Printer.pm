package Pulp::Role::Action::Printer;

use 5.10.0;

use strict;
use warnings;

use Moose::Role;

with 'Pulp::Role::Action';

sub plan_action {
    my( $self, @futures ) = @_;

    return map { my $f1 = $_; $f1->then( sub{
        my $folio = shift or return $f1;

        warn "$self ", $folio->filename;
        $self->print($folio->copy);

        $f1;
    } )
    } @futures;
}

1;


1;
