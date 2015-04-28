package Pulp::Role::Step::Binder;

use strict;
use warnings;

use Moose::Role;
with 'Pulp::Role::Step';

requires 'coalesce';

sub plan_action {
    my( $self, @futures ) = @_;

    Future->needs_all( @futures )->then(sub{
        warn "$self\n";
        
        # TODO current method assume we only get one
        # folio here
        Future->done( $self->coalesce(@_) );
    });
}

1;





