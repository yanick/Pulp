package Pulp::Action::If;

use 5.10.0;

use strict;
use warnings;

use Moose;
use PerlX::Maybe;

with 'Pulp::Role::Action::Editor';

has "condition" => (
    is => 'ro',
    required => 1,
);

has "steps" => (
    isa => 'ArrayRef',
    is => 'ro',
    required => 1,
    traits => [ 'Array' ],
    handles => {
        all_steps => 'elements',
    },
);

sub pulp_new {
    my( $condition, @steps ) = @_;
    return __PACKAGE__->new( condition => $condition, steps => \@steps );
}


sub edit {
    my( $self, $folio ) = @_;

    local $_ = $folio;
    return $folio unless $self->condition->();

    return $Pulp::OnThePress->typeset( [ $folio ], $self->all_steps )
}

1;


