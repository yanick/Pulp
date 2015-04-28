package Pulp::Role::Step::Publisher;

use 5.10.0;


use strict;
use warnings;

use Log::Contextual qw( :log :dlog );

use Moose::Role;

with 'Pulp::Role::Step';

requires 'publish';

sub press {
    my( $self, @folios ) = @_;

    $self->publish($_->copy) for @folios;

    return @folios;
}

1;


1;
