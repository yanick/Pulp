#!/usr/bin/perl 

use strict;
use warnings;

use Pulp::Action::Concat;
use Pulp::Action::Src;
use Pulp::Action::Dest;
use Pulp::Action::Invert;

sub press_run {
    my @sequence = @_;

    my @futures;

    while( my $s = shift @sequence ) {
        @futures = $s->plan_action(@futures);
    }

    Future->needs_all( @futures )->on_ready(
        sub{ warn "all done\n"; }, 
        sub { warn "ooops" }
    );
}

press_run(
    src('src/*'),
    dest('tmp/'),
    invert(),
    concat(),
    dest('dest/'),
);



