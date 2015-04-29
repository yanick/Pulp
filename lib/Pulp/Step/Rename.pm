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

has transform => (
    is => 'ro',
    required => 1,
);

sub pulp_rename {
    my $transform = shift;
    unless( ref $transform ) {
        $transform = $transform =~ m#/$# 
            ? sub { $_ = $transform . $_ }
            : sub { $_ = $transform      }
            ;
    }
    return __PACKAGE__->new( transform => $transform, @_ );
}


sub edit {
    my( $self, $folio ) = @_;

    local $_ = $folio->filename;
    $self->transform->();

    log_info { "renaming " . $folio->filename . ' to ' . $_  };

    $folio->filename($_);

    return $folio;
}

1;


