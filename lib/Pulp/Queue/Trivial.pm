package Pulp::Queue::Trivial;

use strict;
use warnings;

use Moose;

with 'Pulp::Role::Queue';

use Future;

sub add_job {
    my( $pulp, $job ) = @_;
    my $future = Future->new;

    $future->done( $job->() );

    return $future;
}

sub run { return }




1;
