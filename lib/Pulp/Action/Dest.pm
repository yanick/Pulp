package Pulp::Action::Dest;

use strict;
use warnings;

use Moose;
use Moose::Exporter;

use Pulp::Folio;

Moose::Exporter->setup_import_methods(
    as_is => [ 'dest' ]
);

# TODO this should be auto-generated 
sub dest {
    return __PACKAGE__->new( 'dest_dir', @_);
}

has dest_dir => (
    is => 'ro',
);

sub print {
    my( $self, $folio ) = @_;
    $folio->filename( $self->dest_dir . $folio->filename );
    $folio->write;
}

with 'Pulp::Role::Action::Printer';

1;




