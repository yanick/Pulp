package Pulp::Queue;

use strict;
use warnings;

use Future;

sub add_job {
    my $future = Future->new;

    $future->done( (shift)->() );

    return $future;
}

sub run { return }




1;
