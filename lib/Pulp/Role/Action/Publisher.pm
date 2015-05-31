package Pulp::Role::Action::Publisher;

use 5.10.0;


use strict;
use warnings;

use Log::Contextual qw( :log :dlog );

use Future;

use Moose::Role;

with 'Pulp::Role::Action';

requires 'publish';

sub press {
    my( $self, @futures ) = @_;

    my @writing = map {
        my $fut = $_;
        $fut->transform( done => sub{
            my @args = @_;
            for my $f ( @args ) {
                my $copy = $f->copy;
                $self->publish($copy);
            }
            return;
        });
    } @futures;


    return @futures, Future->needs_all(@writing);
}

1;


1;
