use strict;
use warnings;

use Test::More tests => 2;

package Foo {
    use Pulp;
}

use Pulp::Step::Src;

my $foo = Foo->new;

$foo->proof( 'root_dirs' => src( 'a.html', { root_dirs => [ 't/corpus/basic' ] } ) );

my @folios = $foo->press('root_dirs');

is scalar(@folios) => 1, "one file";

is $folios[0]->filename => 'a.html', "relative to root dir";


