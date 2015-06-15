package Example {

use strict;
use warnings;

use Pulp;

use Pulp::Actions 'Src';

proof main => pulp_src( 'corpus/basic/*.html' )

}

use Test::More;

plan tests => 1;

my $pulp = Example->new;

my @folios = $pulp->press('main');

           
pass 'pulp pressed';

is scalar(@folios), 1, "one folio";

is $folios[0]->filename => 'corpus/basic/a.html', 'filename is correct';
