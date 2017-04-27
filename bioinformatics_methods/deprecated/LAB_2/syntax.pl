#!/usr/bin/perl
use warnings;
use strict;

my $bases = "ATGCU";
my $numBasePairs = 3000000000;
my $firstInitial = 'C';

if ($firstInitial eq 'C'){
	print "My first initial is $firstInitial", "\n";
}

printBases($bases);

sub printBases {
	my ($basesWithinSub) = @_;
	print $basesWithinSub, "\n";
}
