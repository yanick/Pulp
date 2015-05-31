package Pulp::Action::Edit;

use 5.10.0;

use strict;
use warnings;

use Moose;

with 'Pulp::Role::Action::Editor';

use Log::Contextual qw( :log :dlog set_logger );

Moose::Exporter->setup_import_methods(
    as_is => [ 'pulp_edit' ]
);

has "transform" => (
    is => 'ro',
    required => 1,
);

sub pulp_edit {
    return __PACKAGE__->new( transform => @_ );
}


sub edit {
    my( $self, $folio ) = @_;

    log_info { "Editing " . $folio->filename  };

    return $self->transform->( $folio );
}

1;


