package Pulp::Queue;

use strict;
use warnings;

use MCE;
use MCE::Queue;

my $q = MCE::Queue->new;

my $index = 1;
my %Q;

sub add_job {
    my( $promise, @args ) = @_;
    $Q{++$index} = $promise;
    $q->enqueue([$index,@args]);
}

sub fullfill_promise {
    my( $pid, @folios ) = @_;
    my $q =  delete $Q{$pid};
    $q->[0]->done(@folios);
}

my $mce = MCE->new(
    user_tasks => [
        { task_name => 'foo',
                max_workers => 2,
            user_func => sub {
                while( my $t = $q->dequeue_nb ) {
                    my( $i, $object, $method, @args )= @$t;
                    MCE->do( 'Pulp::Queue::fullfill_promise', $i, $object->$method(@args) );
                }
            }
        }
    ]
)->run;

sub run {
    $mce->run;
}





