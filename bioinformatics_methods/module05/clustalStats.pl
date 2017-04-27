#!/usr/bin/perl
# Clint Valentine
# 11/4/2016

# TASKS
# Print out the number of sequences found in the MSA
# Print the average identity
# Print the number of residues found in the alignment
# Print the consensus at 50%

use strict;
use warnings;
use diagnostics;

use Pod::Usage;
use Getopt::Long;
use Bio::AlignIO;


# GLOBALS
my $MSAFILE           = './seq.fasta.aln';
my $THRESHOLD_PERCENT = 50;

my $usage   = "\n\n$0 [options]\n
Options:
        -file       Input .msa file <./seq.fasta.aln>
        -threshold  Threshold percent for consensus <50>
        -help       Show this message
\n";
GetOptions(
        'file=s' => \$MSAFILE,
        help     => sub { pod2usage($usage); },
        )
        or pod2usage(2);

my $io = Bio::AlignIO->new(
    -file   => $MSAFILE,
    -format => "clustalw"
);

# Read in the alignment
while ( my $aln = $io->next_aln ) {
    # Get statistics on alignment
    my $num_sequence = $aln->num_sequences;
    my $average_percent_identity = $aln->average_percentage_identity;
    my $num_residues = $aln->num_residues;
    my $consensus_with_threshold = $aln->consensus_string($THRESHOLD_PERCENT);

    printf("Average Identity:                   %.3f%%\n", $average_percent_identity);
    print("Number of Sequences:                $num_sequence\n");
    print("Number of Residues in Alignment:    $num_residues\n");
    print("Consenus at $THRESHOLD_PERCENT%:\n\n$consensus_with_threshold\n");
}
