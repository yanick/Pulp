package Pulp::Actions;

use strict;
use warnings;

use Class::Load 'load_class';

use base 'Exporter::Tiny';

sub _exporter_expand_sub {
    my( $name, $args, $globals ) = @_;

    my $module = "Pulp::Action::$args";
    my $sub_name = 'pulp_' . lc $args;

    return $sub_name => sub {
        try_load_class($module)->pulp_new(@_);
    };
}



1;



