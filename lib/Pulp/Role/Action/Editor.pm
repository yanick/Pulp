package Pulp::Role::Action::Editor;

use strict;
use warnings;

use Future;

use Moose::Role;
with 'Pulp::Role::Action';

requires 'edit';

sub press {
    my( $self, @futures ) = @_;

    my @r = map { 
        $_->transform( done => sub{
            my @folios = @_;
            return map { $self->edit($_->copy) } @folios;
        })
    } @futures;

    return @r;
}

1;





