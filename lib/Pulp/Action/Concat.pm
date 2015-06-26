package Pulp::Action::Concat;

use 5.10.0;

use strict;
use warnings;

use Moose;
with 'Pulp::Role::Action::Binder';

has filename => (
    isa => 'Str',
    is => 'ro',
    required => 1,
);

sub pulp_new {
    my( $class, @args ) = @_;

    return __PACKAGE__->new(filename => @args);
}


sub coalesce {
    my( $self, @folios ) = @_;

    $DB::single = 1;
    

    Pulp::Folio->new(
        filename => $self->filename,
        content => join '', map { $_->content } @folios
    );
}

1;

__END__
