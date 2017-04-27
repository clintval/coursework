#!/usr/bin/perl
use warnings;
use strict;

# Code influenced by examples given by Chuck Roesel

my ($chromosome)  = '/scratch/Drosophila/dmel-2L-chromosome-r5.54.fasta';
my ($fastaOutput) = 'uniqueKmersEndingGG.fasta';

my $sequenceRef   = loadSequence( $chromosome );
my $windowSize    = 23;
my $stepSize      = 1;

my %kmerDir = ();

print `clear`, <<EOF;
In file $chromosome...
Searching for ${windowSize}mers in a sliding window of $stepSize step
Summing all unique ${windowSize}mers found...
EOF

for (
	my $windowStart = 0;
	$windowStart <= ( length( $$sequenceRef ) - $windowSize );
	$windowStart += $stepSize
    ) {
	my $windowSeq = substr( $$sequenceRef, $windowStart, $windowSize );
	processOneFrame( $windowSeq );
}

printHash( \%kmerDir ); # Prints first 1000 GG ending kmer to OUTFILE


close INFILE;
close OUTFILE;
print "Complete.\n";

####Subroutines####

sub processOneFrame {
	my ($windowSeq) = @_;
	if ( defined $kmerDir{ $windowSeq } ) {
		$kmerDir{ $windowSeq }++;
	} else {
		$kmerDir{ $windowSeq } = 1;
	}
}

sub printHash {
	my $hashRef = shift;
	my $counter = 0;
	open ( OUTFILE, ">", $fastaOutput ) or die $!;
	while( $counter < 1000 and my( $kmer, $count ) = each %$hashRef ) {	
		if ( $kmer =~ m/\w*GG$/i ) {
			$counter++;
			print OUTFILE ">crispr_$counter\n$kmer\n";
		}
	}
}
		
sub loadSequence {
	open ( INFILE, "<", @_ ) or die $!;
	my $sequence = "";
	while ( <INFILE> ) {
		chomp;
		if ($_ !~ /^>/ ) {
			$sequence .= $_;
		}
	}
	return \$sequence;
}	
