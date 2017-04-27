#!/usr/bin/perl
use warnings;
use strict;

my $apples = 4;
my $oranges = 7;
my $pears = 3;

my $bananas = $apples;
print "I now have as many bananas as I do apples\n";
print "I have ", $bananas, " bananas\n";

$bananas += $bananas;
print "I now have ", $bananas, " bananas\n";

$bananas -= 2;
print "I how have " , $bananas , " bananas\n";

$bananas *= 2;
print "I now have " , $bananas , " bananas\n";

$apples /= 2;
print "I now have " , $apples , " apples\n";
