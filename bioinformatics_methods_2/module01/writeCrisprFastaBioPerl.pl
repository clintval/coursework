#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;

use Bio::Seq;
use Bio::SeqIO;

# Originally from Chuck Roesel
# Modified by Clint Valentine

# Load into a hash all 21-mers ending in GG from
# dmel-all-chromosome.r6.02.fasta
# where the key is the last 12 positions of the k-mer, and the value is the
# k-mer. Create a second hash to count how many times each 12-mer occurs in the
# genome. For each 12-mer that only occurs ONCE, the corresponding 21-mer is a
# potential CRISPR. Print the crisprs.fasta

# Define in (reference) and out (two for FASTA and Genbank format) files
my $infile = "/scratch/Drosophila/dmel-all-chromosome-r6.02.fasta";
my $faOutfile = "crisprs.fasta";
my $gbOutfile = "crisprs.gb";

# Infile object will take in a Fasta reference
my $in = Bio::SeqIO->new(-file => $infile,
                         -format=> 'Fasta');

# Two outfile objects will write output in FASTA and Genbank formatting
my $faOut = Bio::SeqIO->new(-file => ">$faOutfile",
                            -format => 'Fasta');
my $gbOut = Bio::SeqIO->new(-file => ">$gbOutfile",
                            -format => 'genbank');

# Concatenate all sequences in reference file
my $sequenceRef = "";
while ( my $seq = $in->next_seq() ) {
    $sequenceRef .= $seq->seq;;
}

# Hash to store kmers.
my %kMerHash = ();
# Hash to store occurrences of last 12 positions.
my %last12Counts = ();

# Sliding window parameters.
my $stepSize = 1;
my $windowSize = 21;
my $seqLength = length($sequenceRef);

# for loop to increment the starting position of the sliding window starts at
# position zero; does not move past EOF; advance the window by step-size.
for ( my $windowStart = 0;
      $windowStart <= ( $seqLength - $windowSize );
      $windowStart += $stepSize ) {

  # Get a 21-mer substring from sequenceRef (two $ to deference reference to
  # sequence string) starting at the window start for length $windowStart.
  my $crisprSeq = substr( $sequenceRef, $windowStart, $windowSize );

  # Regex where $1 is the crispr, and $2 contains the last 12 of crispr.
  if ( $crisprSeq =~ /([ATGC]{9}([ATGC]{10}GG))$/ ) {
    # Put the crispr in the hash with last 12 as key, full 21 as value.
    $kMerHash{$2} = $1;
    $last12Counts{$2}++;
  }
}

# Keep track of crispr count to use as crispr ID
my $crisprCount = 0;

# Loop through the hash of last 12 counts.
for my $last12Seq ( keys %last12Counts ) {
  # Check if this sequence is unique
  if ( $last12Counts{$last12Seq} == 1 ) {
    $crisprCount++;

    # Create a BioPerl Seq object to hold this crispr
    my $seqObj = Bio::Seq->new(-seq => "$kMerHash{$last12Seq}",
                               -display_id => ">crispr_$crisprCount",
                               -alphabet => 'dna' );
    $faOut->write_seq($seqObj);
    $gbOut->write_seq($seqObj);
  }
}
