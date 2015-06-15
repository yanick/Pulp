package Example1 {

use strict;
use warnings;

use Pulp;

use Pulp::Actions 'Src';

proof main => pulp_src( 't/corpus/basic/*.html' );

};

1;
