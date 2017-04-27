#!/usr/bin/perl
use warnings;
use strict;

my $dna = 'ATGCU'; # Scalar, sigil $
my @bases = ('A', 'T', 'G', 'C', 'U'); # Array, sigil @
my %purines = (A => 'adenine', G => 'guanine'); # Hash, sigil %
print $dna, "\n";
print @bases, "\n";
print %purines, "\n";
