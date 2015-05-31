#!/usr/bin/perl 

use strict;
use warnings;

use MCE;
use MCE::Queue;

my $q = MCE::Queue->new;

my $index = 4;
my %Q = ( 1 => sub { sleep 5; 1 } ,
    2 => sub { 8}, 
    3 => sub { 9}, 
); 

$q->enqueue($_) for 1..3;

my $mce = MCE->new(
    user_tasks => [
        { task_name => 'foo',
                max_workers => 2,
            user_func => sub {
                while( my $t = $q->dequeue_nb ) {
                    my $r = $Q{$t}->();
                    MCE->say($r);
                    next if $r == 0;
                    $Q{++$index} = sub { $r-1 };
                    $q->enqueue($index);
                }
            }
        }
    ]
)->run;



