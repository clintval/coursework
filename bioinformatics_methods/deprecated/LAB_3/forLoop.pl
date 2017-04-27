#!/usr/bin/perl
use warnings;
use strict;

# Initialize an array of all codons
my @codons = (
'GCT', 'GCC', 'GCA', 'GCG', 'TTA', 'TTG', 'CTT', 'CTC', 'CTA', 'CTG',
'CGT', 'CGC', 'CGA', 'CGG', 'AGA', 'AGG', 'AAA', 'AAG', 'AAT', 'AAC',
'ATG', 'GAT', 'GAC', 'TTT', 'TTC', 'TGT', 'TGC', 'CCT', 'CCC', 'CCA',
'CCG', 'CAA', 'CAG', 'TCT', 'TCC', 'TCA', 'TCG', 'AGT', 'AGC', 'GAA',
'GAG', 'ACT', 'ACC', 'ACA', 'ACG', 'GGT', 'GGC', 'GGA', 'GGG', 'TGG',
'CAT', 'CAC', 'TAT', 'TAC', 'ATT', 'ATC', 'ATA', 'GTT', 'GTC', 'GTA',
'GTG'
);
# Get the count of codons

my $numCodons = @codons;

for (
	my $i = 0 ;          #Initialization
	$i < $numCodons ;    #Test - keep looping while true
	$i++                 #Increment
)
{
	print 'The codon at ',$i,' is ',$codons[$i], "\n";
}
