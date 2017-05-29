#!/usr/bin/perl
use warnings;
use strict;

#declare variables
my $pi1 = 3.14;
my $pi2;
my $pi3;

#copy values
$pi3 = $pi2 = $pi1;

print "pi3 $pi3 pi2 $pi2 pi1 $pi1\n";

##pi2 is a string, but perl will think of it as a number
$pi2 = "3.14";
##can we can then add them, right?
$pi3 = $pi1 + $pi3;
##Let's see
print "pi3 $pi3\n";
##Now if it's a number, or is it a string?
if ($pi2 eq "1"){
	print "1 yes it is, pi2 is equal to 3.14\n";
}
if ($pi2 eq "3.14"){
	print "2 yes it is, pi2 is equal to 3.14\n";
}
if ($pi2 == "3.14"){
	print "3 yes it is, pi2 is equal to 3.14\n";
}
if ($pi2 == $pi1){
	print "4 yes it is, pi2 is equal to pi1\n";
}
