#!/usr/bin/perl 

use strict;
use warnings;

use Pulp;
use Pulp::Action::Concat;
use Pulp::Action::Src;
use Pulp::Action::Dest;
use Pulp::Action::Invert;

press proof_of_concept => [
    src('src/*'),
    dest('tmp/'),
    invert(),
    concat(),
    dest('dest/'),
];



