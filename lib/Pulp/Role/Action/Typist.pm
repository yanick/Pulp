package Pulp::Role::Action::Typist;

use strict;
use warnings;

use Moose::Role;
with 'Pulp::Role::Action';

use Log::Contextual qw( :log :dlog );

requires 'insert';

sub press {
    my( $self, @folios ) = @_;

    return @folios, map {
        $_;
    } $self->insert;
}

1;



