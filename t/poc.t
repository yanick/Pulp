use strict;
use warnings;

use Test::More tests => 2;

use lib 't/lib';
use PoC;

my $poc = PoC->new(
    dest_dir => './tmp',
);

$poc->press('default');

my $dir = $poc->dest_dir;

subtest 'style.css' => sub {
    my $css = $dir->child('style.css');
    ok -f $css, "file exists";

    like $css->slurp => qr/body $_/, "content is there"
        for qw/ div p /;
};

subtest 'html files' => sub {
    subtest $_ => sub {
        ok -f $_, "file exists";
        for ( $_->slurp ) {
            like $_ => qr/style.css/, "style was added";
            like $_ => qr/<html>/, "it's html all right";
        }
    } for map { $dir->child("$_.html") } qw/ a b /;
};




