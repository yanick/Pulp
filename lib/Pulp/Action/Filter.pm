package Pulp::Action::Filter;

use strict;
use warnings;

use Moose;
with 'Pulp::Role::Action::Editor';

has test => (
    is => 'ro',
    required => 1,
);


sub edit {
    my( $self, $folio ) = @_;

    local $_ = $folio;
    my $result = $self->test->() ? $folio : ();
    return $result ? $folio : ();
}


1;
