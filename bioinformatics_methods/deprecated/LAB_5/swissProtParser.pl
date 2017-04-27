#!/usr/bin/perl
use warnings;
use strict;

open INFILE, "<", "example.txt" or die $!;
open OUTFILE, ">", "example.fasta" or die $!;

# Use bitwise flags to avoid rematching lines. Wanted to try them out
my $flags = 0b00000;
my $allOn = 0b11111;
my $regex = '(?<=\S{2}\s{3})([A-Za-z0-9( )_=]*)(?=\.|\;)';

my ($aminos, $accession, $geneNames, $organism,
	$NCBITaxID, $seq, $seqLength, @sequence, @seqs);

while (<INFILE>){
	if (($flags & 0b11110) != $allOn && $_ =~ /^AC/i){
		($accession) = $_ =~ $regex;
		$flags = $flags|0b00001;
	} elsif (($flags|0b11101) != $allOn && $_ =~ /^GN/i){
		($geneNames) = $_ =~ $regex;
		$flags = $flags|0b00010;
	} elsif (($flags|0b11011) != $allOn && $_ =~ /^OS/i){
		($organism) = $_ =~ $regex;
		$flags = $flags|0b00100;
	} elsif (($flags|0b10111) != $allOn && $_ =~ /^OX/i){
		($NCBITaxID) = $_ =~ $regex;
		$flags = $flags|0b01000;
	} elsif (($flags|0b01111) == $allOn || $_ =~ /^SQ/i){
		$flags = $flags|0b10000;
		push @sequence, $_;
	}
}

# New regex for AA count. Almost got away with one does all!
$regex = '(?<=\S{8}\s{3})([A-Za-z0-9( )_=]*)(?=\.|\;)';

# Parse out amino acid counts from header of SQ line
$aminos = $sequence[0];
($aminos) = $aminos =~ $regex;

# Munge DNA into string without whitespace
# Remove header line and 2 trailing footer lines
# Slice every 60 nucleotides for printing
$seqLength = @sequence - 2;
$seq = join("", @sequence[1..$seqLength]);
$seq =~ s/\s+.//g;
(@sequence) = $seq =~ m/(.{60}?)/g;

# Overwrite example.fasta in FASTA format
print OUTFILE ('>', $accession, " | ", $organism, " | ",
	$NCBITaxID, " | ", $aminos, " | ", $geneNames, ".\n");
foreach (@sequence){
	print OUTFILE $_, "\n";
}

close INFILE;
close OUTFILE;
