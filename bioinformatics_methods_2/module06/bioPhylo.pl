#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

use Getopt::Long;
use Pod::Usage;

use Bio::Phylo::IO;
use Bio::Phylo::Treedrawer;

# GLOBALS
my $TREE_FILE = 'myosin.species_labeled.fasta.tree';
my $OUTFILE   = 'tree.species_labeled.svg';
my $usage = "\n\n$0 [options] \n
Options:
    -tree_file    File in Newick format
    -outfile      Place to output file
    -help         Show this message
\n";

# Parse parameters and check requirements
GetOptions(
    'tree_file=s' => \$TREE_FILE,
    'outfile=s'   => \$OUTFILE,
    help          => sub { pod2usage($usage); },
    )
    or pod2usage(2);


open( SVG, ">", $OUTFILE) or die $!;

open( NEWICK, "<", $TREE_FILE );

my $newickString = '';

while ( <NEWICK> ) {
    chomp;
    $newickString .= $_;
}

$newickString .= ';';

my $forest = Bio::Phylo::IO->parse(
    -format => 'newick',
    -string => $newickString,
    );

my $tree = $forest->first;

my $treedrawer = Bio::Phylo::Treedrawer->new(
    -width   => 1920,
    -height  => 1280,
    -shape   => 'CURVY',
    -mode    => 'PHYLO',
    -format  => 'SVG',
    );

$treedrawer->set_scale_options(
    -width => '100%',
    -major => '10%',
    -minor => '2%',
    -label => 'MYA',
    );

$treedrawer->set_tree( $tree );
print SVG $treedrawer->draw;

close SVG;
close NEWICK;
