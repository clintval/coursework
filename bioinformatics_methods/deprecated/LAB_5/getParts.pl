#!/usr/bin/perl
use warnings;
use strict;

my $line = "100\twg\t1015\ttDRSC2265\n";

if($line =~ /^(\d+)\t(\w+)\t(\d+)\t(\w+)/){
	print $1, "\n";
	print $2, "\n";
	print $3, "\n";
	print $4, "\n";
}

