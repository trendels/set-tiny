#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Set::Tiny' );
}

diag( "Testing Set::Tiny $Set::Tiny::VERSION, Perl $], $^X" );
