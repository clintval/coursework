#!/usr/bin/perl
use warnings;
use strict;

$" = "";

my $string = "AATGGTTTCTCCCATCTCTCCATCGGCATAAAAATACAGAATGATCTAACGAA";

my $regex = qr/
		(GT)		# capture start codon
		(.*)		# capture 0 or more of anything
		(AG)		# capture stop codons
		/x;

print `clear`, "Found potential canonical intron sequences:\n";

&findIntrons( $string );

sub findIntrons {
	my @groups = $_[0] =~ m/$regex/ig;
	print "\n\t@groups\n" if @groups;
	&findIntrons( $groups[0] . $groups[1] ) if @groups;
	&findIntrons( $groups[1] . $groups[2] ) if @groups;
}
