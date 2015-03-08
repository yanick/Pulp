#!/usr/bin/perl 

use strict;
use warnings;

use Future;
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
        my $p = path($self->filename);
        $p->parent->mkpath;
        $p->spew($self->content);
    }

}

sub press_run {
    my @sequence = @_;

    my @futures;

    while( my $s = shift @sequence ) {
        @futures = $s->(@futures);
    }

    Future->needs_all( @futures )->on_ready(
        sub{ warn "all done\n"; }, 
        sub { warn "ooops" }
    );

}

sub src {
    my $glob = shift;

    return sub {
        my @futures = @_;

        my @files = glob $glob;

        for my $f ( @files ) {
            warn "creating folio for $f\n";

            push @futures, my $fut = Future->new;

            $fut->done( Pulp::Folio->new( original_filename => $f) );
        }

        return @futures;
    }
}

sub invert {

    return sub {
        my @futures = @_;

        my @futures_out;

        for my $f ( @futures ) {
            push @futures_out, $f->then( sub{
                my $f = Future->new;
                my $folio = shift or return $f->done;
                warn "reversing";
                $folio->content( scalar reverse $folio->content );
                $f->done($folio);
            });
        }

        return @futures_out;
    }
}

sub concat {
    return sub {
        my @futures = @_;

        Future->needs_all( @futures )->then(sub{
            my @folios;

            warn "concat all the folios together\n";

            my $f = Future->new;

            $f->done( Pulp::Folio->new(
                filename => 'all',
                content => join '', map { $_->content } @_
            ));

            return $f;
        });

    }
}

sub dest {
    my $prefix = shift;

    return sub {
        my @futures = @_;

        return map { 
            $_->then(sub{
            
                my $f = Future->new;

                my $folio = shift or return $f->done;

                my $new =
                    Pulp::Folio->new( filename => $folio->filename,
                    content => $folio->content );

                $new->filename( $prefix . $folio->filename );
                warn "writing ", $new->filename;
                $new->write;

                $f->done();

                return $f;
            })
        } @futures;
    }
}

press_run(
    src('src/*'),
    dest('tmp/'),
    invert(),
    concat(),
    dest('dest/'),
);



