package Pulp::Role::Action::Binder;

use strict;
use warnings;

use Moose::Role;
with 'Pulp::Role::Action';

use Future;

requires 'coalesce';

sub press {
    my( $self, @futures ) = @_;


    my $f = 
    Future->needs_all( @futures )->then(sub{
        # TODO current method assume we only get one
        # folio here
        Future->done( $self->coalesce(@_) );
    });
    $DB::single = 1;
    return $f;
}

1;





