package Pulp::Step::Src;

use strict;
use warnings;

use Moose;
use Moose::Exporter;

use Pulp::Folio;

use Log::Contextual qw( :log :dlog );
use Path::Tiny;
use List::AllUtils qw/ uniq /;

# TODO this should be auto-generated 
sub src {
    my $args;
    $args = pop @_ if @_ and ref $_[-1] eq 'HASH';

    return __PACKAGE__->new( sources => [ @_ ], %$args );
}
Moose::Exporter->setup_import_methods(
    as_is => [ 'src' ]
);


has sources => (
    is => 'ro',
    isa => 'ArrayRef',
    traits => [ qw/ Array / ],
    default => sub { [] },
    lazy => 1,
    handles => {
        'all_sources' => 'elements',
    },
);

has root_dirs => (
    is => 'ro',
    isa => 'ArrayRef',
    traits => [ qw/ Array / ],
    default => sub { [ '.' ] },
    lazy => 1,
    handles => {
        'all_root_dirs' => 'elements',
    },
);

sub insert {
    my $self = shift;

    my %files;

    for my $dir ( $self->all_root_dirs ) {
        path($dir)->visit(sub{
            return unless $_->is_file;
            $files{ $_->relative($dir) } ||= $_->absolute;
            return;
        },{ recurse => 1 });
    }

    my @selected;

    for my $source ( $self->all_sources ) {
        log_info { "processing " . $source };
        my $re = $self->path_to_regex($source);
        push @selected, grep { /$re/ } keys %files;
    }

    return map { Pulp::Folio->new(
        original_filename => $files{$_},
        filename => $_,
    )} uniq @selected;
}

sub path_to_regex {
    my( $self, $path ) = @_;

    $path = '^' . quotemeta($path) . '$';

    $path =~ s#\\\*\\\*#.*(?=/|\$)#g;
    $path =~ s#\\\*#[^/]*#g;

    return $path;
}

sub find_file_for {
    my( $self, $source ) = @_;

    for my $dir ( map { path($_) } $self->all_root_dirs ) {
        next unless $dir->child($source)->exists;

        my $file = $dir->child($source);
        
        log_info { "found in $dir : " . $file->relative($dir) };

        return Pulp::Folio->new(
                original_filename => $file->stringify,
                filename => $file->relative($dir)->stringify,
        );
    }

    return;
}

with 'Pulp::Role::Step::Typist';

1;


