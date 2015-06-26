use Test::More;

use lib 't/lib';

plan tests => 3;

use Example1;

my $pulp = Example1->new;

my @folios = $pulp->press('main');
           
pass 'pulp pressed';

is scalar(@folios), 1, "one folio";

is $folios[0]->filename => 't/corpus/basic/a.html', 'filename is correct';
