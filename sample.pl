#!/usr/bin/perl 

use strict;
use warnings;

use Promises qw/ collect deferred /;
use AnyEvent;
use Path::Tiny;

package Pulp::Folio {
    use Moose;
    use Path::Tiny;

    has 'original_filename' => (
        is => 'ro',
    );

    has "content" => (
        isa => 'Str',
        is => 'rw',
        lazy => 1,
        default => sub {
            my $self = shift;

            path($self->original_filename)->slurp;
        },
    );

    has "filename" => (
        isa => 'Str',
        is => 'rw',
        lazy => 1,
        default => sub { $_[0]->original_filename },
    );

    sub write {
        my $self = shift;
        path($self->filename)->spew($self->content);
    }

}

sub press_run {
    my @sequence = @_;

    my @promises;

    my $cv = AnyEvent->condvar;
    
    while( my $s = shift @sequence ) {
        @promises = $s->(@promises);
    }

    collect(@promises)->then(sub{
        warn "all done\n";
            $cv->send("yay");
    }, sub { warn "ooops" });

    print $cv->recv;

}

sub src {
    my $glob = shift;

    return sub {
        my @folios = @_;

        my @files = glob $glob;

        for my $f ( @files ) {
            warn "creating folio for $f\n";
            my $d = deferred;
            $d->resolve( Pulp::Folio->new(
                        original_filename => $f
            ));
            push @folios, $d->promise;
        }

        return @folios;
    }
}

sub invert {

    return sub {
        my @folios = @_;

        my @promises;

        for my $f ( @folios ) {
            my $d = deferred;
            $f->then(sub{
                my $folio = shift;
                $folio->content( scalar reverse $folio->content );
                $d->resolve($folio);
            });
            push @promises, $d->promise;
        }

        return @promises;

    }
}

sub concat {
    return sub {
        my @folios = @_;

        my $d = deferred;

        collect( @folios )->then(sub{
            @_ = map { @$_ } @_;
            warn @_;
            warn "concat all the folios together\n";
            $d->resolve( Pulp::Folio->new(
                filename => 'all',
                content => join '', map { $_->content } @_
            ));
        });

        $d->promise;
    }
}

sub dest {
    my $prefix = shift;

    return sub {
        my @p_in = @_;

        for ( @p_in ) {
            $_->then(sub{
                my $folio = shift;

                sleep 5;

                $folio->filename( $prefix . $folio->filename );
                warn "writing ", $folio->filename;
                $folio->write;
            });
        }

        return @p_in;

    }
}

press_run(
    src('src/*'),
    dest('tmp/'),
    invert(),
    concat(),
    dest('dest/'),
);



