package Pulp::Role::ClassProofs;

use strict;
use warnings;

use Moose::Role;
use MooseX::ClassAttribute;

class_has class_proofs => (
    is => 'ro',
    lazy  => 1,
    isa => 'HashRef',
    traits => [ 'Hash' ],
    default => sub { +{} },
    handles => {
        add_class_proof  => 'set',
        all_class_proofs => 'elements',
        class_proof => 'get',
    },
);


1;

