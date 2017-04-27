#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

use Getopt::Long;
use Pod::Usage;

use Bio::Phylo::IO;
use Bio::Phylo::Treedrawer;

# GLOBALS
my $ACCESSION = '';
my $usage = "\n\n$0 [options] \n
Options:
    -accession    Accession number
    -help         Show this message
\n";

# Parse parameters and check requirements
GetOptions(
    'accession=s' => \$ACCESSION,
    help          => sub { pod2usage($usage); },
    )
    or pod2usage(2);

unless ( $ACCESSION ) {
    die "Provide an accession number, -accession <accession>", $usage;
};

# Download fasta file for protein of accession number and save as file
my $factory = Bio::DB::EUtilities ->new(-eutil   => 'efetch',
                                        -db      => 'protein',
                                        -rettype => 'fasta',
                                        -email   => 'valentine.c@husky.neu.edu',
                                        -id      => $ACCESSION);

$factory->get_Response(-file => "$ACCESSION.fasta");
