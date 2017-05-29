#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;

my $filename = 'sequence.fasta';

unless (open(INFILE, "<", $filename) ) {
	die "Cannot open ", $filename, " ", $!;
}

chomp(my @lines = <INFILE>);
close(INFILE);

# Print @lines with no formatting
print PassByValue(@lines), @lines[1..$#lines], "\n";

# Change $lines[0] to change
sub PassByValue{
	my @values = @_;
	$values[0] = 'changed';	
}
