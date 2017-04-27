#!/usr/bin/perl
use warnings;
use strict;

$" = "";

my $string = "AATGGTTTCTCCCATCTCTCCATCGGCATAAAAATACAGAATGATCTAACGAA";

my $regex = qr/
		(ATG)		# capture start codon
		(.*)		# capture 0 or more of anything
		(T[AG][GA])	# capture stop codons
		/x;

print `clear`, "Found potential coding sequences:\n";

&findCoding( $string );

sub findCoding {
	my @groups = $_[0] =~ m/$regex/ig;
	print "\n\t@groups\n" if @groups;
	&findCoding( $groups[0] . $groups[1] ) if @groups;
	&findCoding( $groups[1] . $groups[2] ) if @groups;
}
