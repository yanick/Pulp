package Pulp;

use strict;
use warnings;

use Log::Contextual qw( :log :dlog set_logger );
use Log::Dispatchouli;

set_logger( Log::Dispatchouli->new({
   ident     => 'pulp',
   to_stdout => 1,
   debug     => 1,
}) );
 
 
log_debug { 'program started' };

use Moose::Role;

#use Moose::Exporter;
use Moose::Util qw/ apply_all_roles /;

with 'Pulp::Role::ClassProofs';



Moose::Exporter->setup_import_methods(
    as_is => [ 'proof' ],
);

#sub init_meta {
#    shift;
#    my $meta = Moose->init_meta( @_ );
#    $meta->superclasses( 'Pulp' );
#    apply_all_roles( $meta, 'Pulp::Role::ClassProofs' );
#    return $meta;
#}

has 'proofs' => (
    is => 'ro',
    isa => 'HashRef',
    traits => [ 'Hash' ],
    lazy => 1,
    default => sub {
        +{ shift->all_class_proofs }
    },
    handles => {
        '_proof' => 'get',
        'add_proof' => 'set',
        'proof_labels' => 'keys',
        'nbr_proofs' => 'count',
    },
);

my %commands;

sub proof {
    # we can be called in 2 ways: as the pre-build step,
    # or as a normal method
    #

    my $object = ref($_[0]) && shift;

    my( $identifier, @chain ) = @_;

    if ( @chain ) {
        if( $object ) {
            $object->add_proof( $identifier => \@chain );
        }
        else {
            scalar(caller)->add_class_proof( $identifier => \@chain );
        }
    }

    return $object ? $object->_proof($identifier) : scalar(caller)->class_proof($identifier)
}

sub typeset {
    my( $self, $folios, @chain ) = @_;

    return @$folios unless @chain;

    my $next = shift @chain 
        or return $self->typeset( $folios, @chain );

    if ( ref $next eq 'ARRAY' ) {
        my @f;
        for my $c ( @$next ) {
            push @f, $self->typeset( [ map { $_->copy } @$folios ], ref $c eq 'ARRAY' ? @$c : $c );
        }

        return $self->typeset( \@f => @chain );
    }

    if ( ref $next eq 'CODE' ) {
        return $self->typeset( $folios, $next->($self), @chain );
    }

    return $self->typeset( [ $next->press(@$folios) ] => @chain );
}

sub press {
    my( $self, $name, @folios ) = @_;

    my $steps = $self->proof($name);

    log_info { "pressing $name" };

    local $Pulp::OnThePress = $self;

    @folios = $self->typeset(\@folios, @$steps);

    log_info { "$name is off the press" };

    return @folios;
}

1;

