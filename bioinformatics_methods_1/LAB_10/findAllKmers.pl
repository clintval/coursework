#!/usr/bin/perl
use warnings;
use strict;

# Code influenced by examples given by Chuck Roesel

my ($chromosome) = '/scratch/Drosophila/dmel-2L-chromosome-r5.54.fasta';

my $sequenceRef = loadSequence( $chromosome );
my $windowSize = 15;
my $stepSize = 1;

my %kmerDir =();

print `clear`, <<EOF;
In file $chromosome...
Searching for ${windowSize}mers in a sliding window of $stepSize
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

printHash( \%kmerDir );

####Subroutines####

sub processOneFrame {
	my ($windowSeq) = @_;
	if ( defined $kmerDir{ $windowSeq } ) {
		$kmerDir{ $windowSeq } += 1;
	} else {
		$kmerDir{ $windowSeq } = 1;
	}
}

sub printHash {
	my $hashRef = shift;
	while( my( $kmer, $count ) = each %$hashRef ) {	
		print "$kmer\t$count\n";
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
