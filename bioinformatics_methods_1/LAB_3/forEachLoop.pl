#!/usr/bin/perl
use warnings;
use strict;

#Initialize an array of all codons
my @codons = (
	'GCT', 'GCC', 'GCA', 'GCG', 'TTA', 'TTG', 'CTT', 'CTC', 'CTA', 'CTG',
	'CGT', 'CGC', 'CGA', 'CGG', 'AGA', 'AGG', 'AAA', 'AAG', 'AAT', 'AAC',
	'ATG', 'GAT', 'GAC', 'TTT', 'TTC', 'TGT', 'TGC', 'CCT', 'CCC', 'CCA',
	'CCG', 'CAA', 'CAG', 'TCT', 'TCC', 'TCA', 'TCG', 'AGT', 'AGC', 'GAA',
	'GAG', 'ACT', 'ACC', 'ACA', 'ACG', 'GGT', 'GGC', 'GGA', 'GGG', 'TGG',
	'CAT', 'CAC', 'TAT', 'TAC', 'ATT', 'ATC', 'ATA', 'GTT', 'GTC', 'GTA',
	'GTG'
); 

#Loop through codons array, and for each pass assign the current codon to $codon
foreach my $codon (@codons)
{
print $codon, "\n";
} 
