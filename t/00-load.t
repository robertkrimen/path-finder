#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Path::Finder' );
}

diag( "Testing Path::Finder $Path::Finder::VERSION, Perl $], $^X" );
