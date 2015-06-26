package Pulp::Action::Debug;

use strict;
use warnings;

use Moose;

use Pulp::Folio;

use Path::Tiny;
use Data::Printer;

has "label" => (
    isa => 'Str',
    is => 'ro',
);

sub pulp_new {
    my( $class, @args ) = @_;
    unshift @args, 'label' if @args == 1;
    __PACKAGE__->new( @args );
}

sub edit {
    my( $self, @folios ) = @_;
    warn $self->label, "\n";
    p $_ for @folios;
    return @folios;
}

with 'Pulp::Role::Action::Editor';

1;






