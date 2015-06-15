package Pulp::Queue::Trivial;

use strict;
use warnings;

use Moose;

with 'Pulp::Role::Queue';

use Future;

sub add_job {
    my $future = Future->new;

    $future->done( (shift)->() );

    return $future;
}

sub run { return }




1;
