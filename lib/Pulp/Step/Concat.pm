package Pulp::Step::Concat;

use 5.10.0;

use strict;
use warnings;

use Moose;
with 'Pulp::Role::Step::Coalesce';

Moose::Exporter->setup_import_methods(
    as_is => [ 'concat' ]
);

# TODO this should be auto-generated 
sub concat {
    return __PACKAGE__->new(@_);
}


sub coalesce {
    my( $self, @folios ) = @_;

    Pulp::Folio->new(
        filename => 'all',
        content => join '', map { $_->content } @folios
    );
}

1;

__END__
