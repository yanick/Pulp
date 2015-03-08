package Pulp;

use strict;
use warnings;

my %commands;

use parent 'Exporter';

our @EXPORT = ( 'press' );

sub press {
    my( $name, $chain ) = @_;
    $commands{$name} = $chain;
}

END {
    my $command = shift @ARGV or exit print "available commands: ", join ' ', keys %commands;

    my @futures;

    while( my $s = shift @{$commands{$command}} ) {
        @futures = $s->plan_action(@futures);
    }

    Future->needs_all( @futures )->on_ready(
        sub{ warn "all done\n"; }, 
        sub { warn "ooops" }
    );
}




1;

