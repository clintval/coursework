#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;

my $range = 100;
my @hundred_rand = ();

for(my $i = 0; $i < 100; $i++){
	$hundred_rand[$i] = rand(100);
}

# Sort one hundred random numbers by increasing numeric order
my @hundred_rand_sort = sort {$a <=> $b} (@hundred_rand);

# Tell the user to prepare!
print "These are the lowest ten numbers\nfrom a 100 random number generation\n***********************\n";

# Print those digits! Tab delimited 10 lowest
for my $i (0..9){
	print $hundred_rand_sort[$i], "\t";
}

print "\n"
