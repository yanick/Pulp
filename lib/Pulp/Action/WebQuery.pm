package Pulp::Action::WebQuery;

use strict;
use warnings;

use Web::Query;

use Moose;

with 'Pulp::Role::Action::Editor';

sub pulp_new {
    my( $class, @args ) = @_;
    __PACKAGE__->new( 'code', @args );
}

has "code" => (
    is => 'ro',
    required => 1,
);

sub edit {
    my( $self, $folio ) = @_;

    local $_ = Web::Query->new( $folio->content );

    $self->code->( $folio );

    $folio->content( $_->as_html );

    return $folio;
}

1;




