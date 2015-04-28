package Pulp::Step::Rename;

use 5.10.0;

use strict;
use warnings;

use Moose;
use CSS::LESSp;
with 'Pulp::Role::Step::Editor';

use Log::Contextual qw( :log :dlog set_logger );

Moose::Exporter->setup_import_methods(
    as_is => [ 'pulp_rename' ]
);

has [ qw/ from to / ] => (
    is => 'ro',
    required => 1,
);

sub pulp_rename {
    return __PACKAGE__->new( from => $_[0], to => $_[1] );
}


sub edit {
    my( $self, $folio ) = @_;

    my $re = $self->from;
    my $new_name = $folio->filename =~ s/$re/$self->to/er;

    log_info { "renaming " . $folio->filename . ' to ' . $new_name  };

    $folio->filename( $new_name );

    return $folio;
}

1;


