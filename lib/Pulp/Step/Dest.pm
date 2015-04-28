package Pulp::Step::Dest;

use strict;
use warnings;

use Moose;
use Moose::Exporter;

use Log::Contextual qw( :log :dlog set_logger );

use Pulp::Folio;

use Path::Tiny;

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

sub publish {
    my( $self, $folio ) = @_;
    $folio->filename( path($self->dest_dir)->child($folio->filename)->stringify );
    $folio->write;
    log_info { "writing " . $folio->filename };
}

with 'Pulp::Role::Step::Publisher';

1;




