package Pulp::Queue;

use strict;
use warnings;

use MCE;
use MCE::Queue;

my $q = MCE::Queue->new;

my $index = 1;
my %Q;

sub add_job {
    my( $promise, $sub ) = @_;
    $Q{++$index} = [ $promise, $sub ];
    $q->enqueue($index);
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
                    use DDP;
                    warn keys %Q;
                    my( undef, $sub ) = @{ $Q{$t} };
                    MCE->do( 'Pulp::Queue::fullfill_promise', $t, $sub->() );
                }
            }
        }
    ]
)->run;

sub run {
    $mce->run;
}





