#!/usr/bin/perl
use warnings;
use strict;

my $file = 'DNAtest.fasta';

$/ = ">";

unless (open(INFILE, "<", $file) ) {
	die "Can't open ", $file, " ", $!;
}

my $sequenceCount = 0;

while (<INFILE>){
	chomp;
	if($_){
		$sequenceCount++;
		print $sequenceCount, "\t", $_, "\n";
	}
}
close INFILE;
$/ = " ";
