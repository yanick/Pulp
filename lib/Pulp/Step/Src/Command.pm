package Pulp::Step::Src::Command;

use strict;
use warnings;

use Moose;
use Moose::Exporter;

use Pulp::Folio;

use Log::Contextual qw( :log :dlog );
use Path::Tiny;
use List::AllUtils qw/ uniq /;
use IPC::Cmd qw/ run /;

# TODO this should be auto-generated 
sub src_command {
    my $filename = shift;

    return __PACKAGE__->new( filename => $filename, command => [ @_ ] );
}
Moose::Exporter->setup_import_methods(
    as_is => [ 'src_command' ]
);


has filename => (
    is => 'ro',
    required => 1,
);

has command => (
    is => 'ro',
    isa => 'ArrayRef',
    traits => [ qw/ Array / ],
    required => 1,
    handles => {
        'all_command' => 'elements',
    },
);

sub insert {
    my $self = shift;

    log_info { "generating " . $self->filename . " from " . join " ", $self->all_command };

    my( $success, $error, undef, $stdout, $stderr ) 
        = run( command => join ' ', $self->all_command );


    unless( $success ) {
        log_info { $error . ' '. join ' ', @$stderr };
        return;
    }

    return Pulp::Folio->new(
        filename => $self->filename,
        content => join '', @$stdout,
    );
}

with 'Pulp::Role::Step::Typist';

1;




