package Pulp::Role::Action::Publisher;

use 5.10.0;


use strict;
use warnings;

use Log::Contextual qw( :log :dlog );

use Moose::Role;

with 'Pulp::Role::Action';

requires 'publish';

sub press {
    my( $self, @folios ) = @_;

    $self->publish($_->copy) for @folios;

    return @folios;
}

1;


1;
