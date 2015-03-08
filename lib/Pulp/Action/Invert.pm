package Pulp::Action::Invert;

use 5.10.0;

use strict;
use warnings;

use Moose;
with 'Pulp::Role::Action::Edit';

Moose::Exporter->setup_import_methods(
    as_is => [ 'invert' ]
);

# TODO this should be auto-generated 
sub invert {
    return __PACKAGE__->new(@_);
}


sub edit {
    my( $self, $folio ) = @_;

    $folio->content( scalar reverse $folio->content );

    return $folio;
}

1;
