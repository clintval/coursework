#!/usr/bin/perl
use warnings;
use strict;

my @listing = `ls -l`;

foreach(@listing){
	chomp;
	print $_, "\n";
}
