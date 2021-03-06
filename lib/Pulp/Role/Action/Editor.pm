package Pulp::Role::Action::Editor;

use strict;
use warnings;

use Future;

use Moose::Role;
with 'Pulp::Role::Action';

requires 'edit';

use Future;

sub press {
    my( $self, @futures ) = @_;

    return map {
        $_->then(sub{
            my @folios = @_;
            my $next = Future->new;

            my @nexts = map {
                my $f = $_;
                $Pulp::OnThePress->add_job( sub{ $self->edit($f) } )
            } @folios;

            return Future->needs_all(@nexts);
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





