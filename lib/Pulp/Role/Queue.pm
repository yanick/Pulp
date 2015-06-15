package Pulp::Role::Queue;

use strict;
use warnings;

use Moose::Role;

requires 'add_job', 'run';


1;
