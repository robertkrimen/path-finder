#!/usr/bin/perl -w

use strict;
use warnings;

use Test::Most;

plan qw/no_plan/;

use Path::Finder;

my $finder = Path::Finder->new;
my $match;

$finder->target(path => 'a');
$finder->target(path => 'a/b/c', rank => 1);

ok($match = $finder->find('a'));
is($match->found, 1);
