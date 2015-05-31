package Pulp::Action::Xslate;

use 5.10.0;

use strict;
use warnings;

use Moose;
use Text::Xslate;
use PerlX::Maybe;

with 'Pulp::Role::Action::Editor';

use Log::Contextual qw( :log :dlog set_logger );

Moose::Exporter->setup_import_methods(
    as_is => [ 'xslate' ]
);

has "template_vars" => (
    isa => 'HashRef',
    is => 'ro',
    lazy => 1,
    default => sub { +{} },
);

has "path" => (
    is => 'ro',
);

has engine => (
    is => 'ro',
    lazy => 1,
    default => sub { 
        my $self = shift;
        Text::Xslate->new(
            maybe path => $self->path,
        );
    },
);

sub xslate {
    unshift @_, 'template_vars' if @_;

    return __PACKAGE__->new( @_ );
}


sub edit {
    my( $self, $folio ) = @_;

    log_info { "Xslating " . $folio->filename  };

    $folio->content( $self->engine->render_string( $folio->content, $self->template_vars ) );

    return $folio;
}

1;
