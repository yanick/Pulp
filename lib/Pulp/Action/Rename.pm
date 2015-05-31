package Pulp::Action::Rename;

use 5.10.0;

use strict;
use warnings;

use Moose;
with 'Pulp::Role::Action::Editor';

use Log::Contextual qw( :log :dlog set_logger );

has transform => (
    is => 'ro',
    required => 1,
);

sub BUILDARGS {
    my ( $class, @args ) = @_;
    return { transform => shift @args };
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


