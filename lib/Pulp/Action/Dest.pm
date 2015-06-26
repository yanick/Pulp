package Pulp::Action::Dest;

use strict;
use warnings;

use Moose;
use Moose::Exporter;

use Log::Contextual qw( :log :dlog set_logger );

use Pulp::Folio;

use Path::Tiny;

has dest_dir => (
    is => 'ro',
);

sub pulp_new {
    my( $class, @args ) = @_;
    unshift @args, 'dest_dir' if @args == 1;
    __PACKAGE__->new( @args );
}

sub publish {
    my( $self, $folio ) = @_;
    $folio->filename( path($self->dest_dir)->child($folio->filename)->stringify );
    $folio->write;
    log_info { "writing " . $folio->filename };
}

with 'Pulp::Role::Action::Publisher';

1;




