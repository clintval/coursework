#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;

my @arr = (1,2,3,4,5,6);

my ($total, $count, $average) = findStatsOfArray(@arr);

print "Total: ", $total, "\n";
print "Count: ", $count, "\n";
print "Average ", $average, "\n";


sub findStatsOfArray {
	my @numbers = @_;
	my ($total, $count, $average) = 0;

	foreach (@numbers){
		$count += 1;
		$total += $_;
	}

	$average = $total / $count;
	return ($total, $count, $average);
}

