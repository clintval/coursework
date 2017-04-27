#!/usr/bin/perl
use warnings;
use strict;

my $var;

# Ask the user to enter a value
print 'Enter a value to see if it evaluates to true or false', "\n";

# Get on line of user input
$var = <STDIN>;

# Remove end-of-line characters
chomp($var);

if ($var) {
	print "$var evaluates to true", "\n";
	if ( length $var > 10 ) {
		print "length of $var is greater than 10", "\n";
	} 
	elsif ( $var > 10 ) {
		print "the numeric value of $var is greater than 10", "\n";
	}
	elsif ( $var eq 'ATGC') {
		print "the string $var is equal to ATGC", "\n";
	}
	elsif ( $var gt 'N') {
		print "the alpha value of $var is greater than N", "\n";
	} 
}
else {
	print "$var evaluates to false", "\n";
}
