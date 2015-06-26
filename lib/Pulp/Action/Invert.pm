package Pulp::Action::Invert;

use 5.10.0;

use strict;
use warnings;

use Moose;
with 'Pulp::Role::Action::Edit';


sub edit {
    my( $self, $folio ) = @_;

    $folio->content( scalar reverse $folio->content );

    return $folio;
}

1;
