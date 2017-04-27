#!/usr/bin/perl
use warnings;
use strict;
use Data::Dumper;

# Code influenced by examples given by Chuck Roesel

my ($chromosome)  = '/scratch/Drosophila/dmel-all-chromosome-r6.02.fasta';
my ($fastaOutput) = 'uniqueKmersEndingGG.fasta';

my $subjectRef    = loadSequence( $chromosome );
my $uniqueLen     = 12;
my $CRISPRLen     = 21;

my $stepSize      = 1;

my %last12hash    = ();
my %kmerDir       = ();

print "Scanning $chromosome...\n";

stringScanner( $subjectRef, $uniqueLen, $stepSize , \%last12hash );
stringScanner( $subjectRef, $CRISPRLen, $stepSize , \%kmerDir);

print "Writing all CRISPRs to $fastaOutput\n";

findCRISPR( \%kmerDir, \%last12hash );

print "Exiting...\n";
exit;

#---------------------------------------------
#Loads complete sequence from source file
#Returns string reference to complete sequence
#---------------------------------------------

sub loadSequence {
    my $subject = '';

    open ( INFILE , '<', @_ ) or die $!;

    while ( <INFILE> ) {
        chomp;
        if ( $_ !~ /^>/ ) {
            $subject .= $_;
        }
    }
    close INFILE;
    return \$subject;
}

#---------------------------------------------
#Scanning window frames of $subjectRef
#Passes each frame to processOneFrame to check
#   for uniqueness and counts duplicates
#---------------------------------------------

sub stringScanner {
    my ( $subjectRef, $windowSize, $stepSize , $finalHashRef ) = @_;

    for (
        my $windowStart = 0;
        $windowStart <= ( length ( $$subjectRef ) - $windowSize );
        $windowStart += $stepSize
        ) {
        my $windowSeq = substr( $$subjectRef, $windowStart, $windowSize );
        processOneFrame( $windowSeq, $finalHashRef );
        }
}


sub processOneFrame {
    my ( $windowSeq, $finalHashRef ) = @_;

    if ( defined $finalHashRef->{ $windowSeq } ) {
        $finalHashRef->{ $windowSeq }++;
    } else {
        $finalHashRef->{ $windowSeq } = 1;
    }
}

#---------------------------------------------
#Compares last 12 positions of every potential
#   CRISPR in $kmerDir to $last12hash
#   If unique in genome, write to OUTFILE
#---------------------------------------------

sub findCRISPR {
    my ( $kmerDirRef, $last12hashRef ) = @_;
    my $counter = 0;

    open ( OUTFILE, ">", $fastaOutput ) or die $!;

    while ( my( $kmer, $_ ) = each %$kmerDirRef ) {
        if ( $kmer =~ m/(\w{10}GG$)/i and $last12hashRef->{ $1 } == 1) {
            print OUTFILE ">crispr_$counter\n$kmer\n";
            $counter++;
        }
    }
    close OUTFILE;
}
