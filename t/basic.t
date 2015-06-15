#!/usr/bin/perl 

use strict;
use warnings;

use Test::More;
use Path::Tiny;

plan tests => 2;

package Sample {

    use Pulp;

    use Pulp::Actions qw/ Src Dest Rename /;

    use Path::Tiny;

    has dest_dir => (
        is => 'ro',
        lazy => 1,
        default => sub {
            Path::Tiny->tempdir;
        }
    );

    proof default => sub {
        my $pulp = shift;

        return pulp_src('t/corpus/basic/*' ) 
            => pulp_rename( sub { s#^t/corpus/basic/## } )
            => pulp_dest( $pulp->dest_dir );
    }
}

my $sample = Sample->new;

$sample->press('default');

my $file = path( $sample->dest_dir->child( 'a.html' ) );

ok $file->exists, "file has been moved";

like $file->slurp, qr/Hello world/i, "content is there";



