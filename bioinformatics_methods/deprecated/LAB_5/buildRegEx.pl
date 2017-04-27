#!/usr/bin/perl
use warnings;
use strict;

my $line = "100\twg\n";

if($line =~ /(\d+)\t/){
	print $1, "\n";
}
