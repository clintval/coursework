#!/usr/bin/perl
# Clint Valentine
# 1/27/2016
use warnings;
use strict;

my $infile = "/scratch/RNASeq/blastp.outfmt6";

parseBlast();

sub parseBlast {
	# Open filehandle for blast output
	open( BLAST6, "<", $infile ) or die $!;

	# Read entry line-by-line
	while (<BLAST6>) {
		chomp;

		my $pattern = qr/
			(?<transcript>.*?)\|   # Match transcript field
			(?<isoform>.*?)\tgi\|  # Match isoform field
			(?<gi>.*?)\|sp\|       # Match GI ID field
			(?<sp>.*?)\|           # Match sp field
			(?<prot>.*?)\t         # Match protien ID field
			(?<pident>.*?)\t       # Match percent identity field
			(?<length>.*?)\t       # Match length field
			(?<mismatch>.*?)\t     # Match mismatch field
			(?<gapopen>.*?)\t      # Match gaps open field
			/x;

		# Match line to pattern and print out groups in tab delimination
		if ( $_ =~ /$pattern/ ) {
			print join "\t", $+{transcript}, $+{isoform}, $+{gi}, $+{sp}, $+{prot},
				$+{pident}, $+{length}, $+{mismatch}, $+{gapopen} . "\n";
		}
	}
}
