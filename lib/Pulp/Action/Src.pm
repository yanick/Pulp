package Pulp::Action::Src;

use strict;
use warnings;

use Moose;
use Moose::Exporter;

use Pulp::Folio;

# TODO this should be auto-generated 
sub src {
    return __PACKAGE__->new('src_dir',@_);
}
Moose::Exporter->setup_import_methods(
    as_is => [ 'src' ]
);


has src_dir => (
    is => 'ro',
);

sub insert {
    return map { Pulp::Folio->new( original_filename => $_ ) } glob $_[0]->src_dir;
}

with 'Pulp::Role::Action::Injector';

1;


