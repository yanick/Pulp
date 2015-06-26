package Example2 {

use strict;
use warnings;

use Pulp;

use Pulp::Actions 'Src', 'Dest', 'Rename';

proof main => pulp_src( 't/corpus/basic/*.html' );

};

1;
