package Pulp::Actions;

use strict;
use warnings;

use Class::Load 'load_class';

use base 'Exporter::Tiny';

sub _exporter_expand_sub {
    my( $name, $args, $globals ) = @_;

    my $module = "Pulp::Action::$args";
    my $sub_name = lc "pulp_$args";

    return $sub_name => sub {
        load_class($module)->new(@_);
    };
}



1;



