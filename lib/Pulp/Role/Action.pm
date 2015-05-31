package Pulp::Role::Action;

use 5.10.0;

use strict;
use warnings;

use Moose::Role;

use Log::Contextual qw( :log :dlog );

requires 'press';

1;

__END__
