#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;


my $dna1 = "atggttt";

print "DNA1: ", $dna1, "\n" x2, "Reverse DNA1: ", reverseSequence($dna1), "\n" x2;

sub reverseSequence {
	my ($value) = @_;
	my $rev_value = reverse $value;
}
