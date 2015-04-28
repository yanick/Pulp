use strict;
use warnings;

use Test::More tests => 3;

package Foo {
    use Pulp;

    use Pulp::Step::Src;
    use Pulp::Step::Dest;

    proof foo => src('a') => dest('b');
}

package Bar {
    use Pulp;

    use Pulp::Step::Src;
    use Pulp::Step::Dest;

    proof bar => src('a') => dest('b');
}

my $bar = Bar->new;
is( $bar->nbr_proofs => 1, "no merging of proofs" );

is_deeply [ $bar->proof_labels ] => [ 'bar' ], "it's bar";

subtest "can add to the object" => sub {
    $bar->proof( 'baz' => sub{} );
    is $bar->nbr_proofs => 2, "now there's 2";
    is( Bar->new->nbr_proofs => 1, "main class unchanged" );
};


