#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;

my @hundred_rand = ();

for my $i (0..20){
	$hundred_rand[$i] = rand(100);
}

(my $mean, my $median, my $variance, my $stdev) = get_stats(@hundred_rand);

print "Mean: $mean\n";
print "Median: $median\n";
print "Variance: $variance\n";
print "St. Deviation: $stdev\n";

sub get_stats {
	my @numbers = sort {$a <=> $b} (@_);
	(my $sum, my $mean, my $midpoint, my $median, my $variance, my $stdev) = 0;

	# Calculate total numbers in array
	my $numbers = @numbers;

	# Calculate $sum of all numbers
	foreach my $item (@numbers){
		$sum += $item;
	}

	# Calculate $mean
	$mean = $sum / $numbers;

	# Calculate $median
	$midpoint = (($numbers / 2 ) - 1);
	$median = $numbers[$midpoint];

	# Calculate $variance
	foreach my $item (@numbers){
		$variance += (($item - $mean)**2) / ($numbers - 1);
	}
	
	# Calculate $stdev
	$stdev = sqrt($variance);
	
	return ($mean, $median, $variance, $stdev);
}
