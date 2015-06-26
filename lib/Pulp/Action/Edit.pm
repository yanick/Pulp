package Pulp::Action::Edit;

use 5.10.0;

use strict;
use warnings;

use Moose;

with 'Pulp::Role::Action::Editor';

has "transform" => (
    is => 'ro',
    required => 1,
);

sub pulp_new {
    my( $class, @args ) = @_;
    __PACKAGE__->new( transform => @args );
}


sub edit {
    my( $self, $folio ) = @_;

    log_info { "Editing " . $folio->filename  };

    return $self->transform->( $folio );
}

1;


