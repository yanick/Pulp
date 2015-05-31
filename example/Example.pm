package Example;

use strict;
use warnings;

use Pulp;

use Pulp::Actions 'Src', 'Less', 'Dest', 'Rename';

proof css => pulp_src( 'src/*.less' )
  => pulp_rename( sub { s#^src/## } )
  => pulp_less() ;
#   => pulp_dest( 'tmp/' );
#          => pulp_concat( 'style.css' )
#          => pulp_dest( 'dest/' );


my $pulp = Example->new;
$pulp->press('css');
           
1;
