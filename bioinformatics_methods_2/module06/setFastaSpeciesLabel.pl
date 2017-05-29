#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

use Bio::Seq;
use Bio::SeqIO;

# Notice that the edge descriptions aren't particularly helpful.
# This is because the default fasta file produced by blastdbcmd includes a very
# long header, all of which Bio::Phylo attempts to fit in the tree. Write a
# Perl script to modify the fasta file used as input to mafft so the tree
# descriptions are more useful. The fasta file should just include the species
# name since these are all myosin proteins. Align the modified fasta file with
# mafft, then rerun the tree script.

# Edit myosin.fasta

my $infile = 'myosin.fasta';
my $outfile = 'myosin.species_labeled.fasta';

# Infile object will take in a Fasta reference
my $faIn = Bio::SeqIO->new(-file => $infile,
                         -format=> 'Fasta');


my $faOut = Bio::SeqIO->new(-file => ">$outfile",
                            -format => 'Fasta');


while ( my $seq = $faIn->next_seq() ) {
    $seq->desc =~ /\[(.*?)\]/ig;

    my $species = $1 // 'NA';
    $species =~ s/ /_/g;

    # Create a BioPerl Seq object to hold this modified fasta entry
    my $seqObj = Bio::Seq->new(-seq        => $seq->seq,
                               -display_id => "$species",
                               -desc       => "",
                               -alphabet   => 'dna' );
    $faOut->write_seq($seqObj);
}
