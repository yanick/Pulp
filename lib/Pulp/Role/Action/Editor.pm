package Pulp::Role::Action::Editor;

use strict;
use warnings;

use Future;

use Moose::Role;
with 'Pulp::Role::Action';

requires 'edit';

use Pulp::Queue;
use Future;

sub press {
    my( $self, @futures ) = @_;

    return map {
        $_->then(sub{
            my @folios = @_;
            my $next = Future->new;

            Pulp::Queue::add_job( $next => sub {
                map { $self->edit($_->copy) } @folios;
            } );

            return $next;
        });
    } @futures;

    my @r = map { 
        $_->transform( done => sub{
            my @folios = @_;
            return map { $self->edit($_->copy) } @folios;
        })
    } @futures;

    return @r;
}

1;





