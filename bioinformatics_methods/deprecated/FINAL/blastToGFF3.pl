#!/usr/bin/perl
use warnings;
use strict;
use Data::Dumper;

#Author: C Roesel
#Creation Date: November 15 2013
#Edits: C Valentine

#This program executes BLAST and parses the output in a single step.
#This can be useful when you will need to convert the BLAST output to
#another format. If for example you expect to produce 20G BLAST
#output, then reformat that output to another 20G file in a different
#format, you avoid having to use 20G disk space for a temporary file.

open( GFF3, ">", 'crispr.gff3' ) or die $!;

my %offTarget = ();
my %onTarget  = ();

blastOligos();

foreach my $key ( keys %onTarget ) {
	findMatches( $key );
}

print "Complete\n";
close GFF3;

#--------------------------------------------------------------
#Runs command to BLAST all CRISPRs in uniqueKmersEndingGG.fasta
#Runs processBlastOutputLine on each line for binning into
#	either %offTarget or %onTarget hashes
#--------------------------------------------------------------

sub blastOligos {
	my @commandAndParams = (
	'blastn', '-task blastn',
	'-db /scratch/blast/DrosophilaAllChroms',
	'-query uniqueKmersEndingGG.fasta',
	'-outfmt 6'
	);

	print "@commandAndParams\n";

	open( BLAST, "@commandAndParams |" );

	while (<BLAST>) {
		chomp;
		my $blastOutputLine = $_;
		processBlastOutputLine($blastOutputLine);
	}
}

#--------------------------------------------------------------------
#Each BLAST hit ($blastOutputLine) is parsed and examined
#
#Off target hits for each CRISPR are counted in %offTarget hash e.g.:
#	crispr_xxx => 5
#On target hits are sent to %onTarget with undefined values e.g.:
#	$blastOutputLine => undef
#--------------------------------------------------------------------

sub processBlastOutputLine {
	my ($blastOutputLine) = @_;
	if ( $blastOutputLine !~ /^#/ ) {
		my @blastColumns = split( "\t", $blastOutputLine );
		my (
		$queryId, $chrom, $identity, $length, $mismatches,
		$gaps,    $qStar, $qEnd,     $start,  $end
		) = @blastColumns;
				
		if ( $identity < 100.00 and $mismatches <= 3 and $length == 21 ) {
			$offTarget{ $queryId }++;
		}

		if ( $identity == 100.00 and $length == 21 ) {
			$onTarget{ $blastOutputLine }  = undef;
		}
	}
}

#-----------------------------------------------------------------------
#Each key ($blastOutputLine) in %onTarget is iterated through and parsed
#BLAST hit is converted to GFF3 output and the $offTargetMatches are
#	grabbed from %offTarget using the $queryId e.g.:
#		$queryId = 'crispr_XXX' from @blastColumns
#		$offTarget{ $queryId } returns sum of off-target matches
#GFF3 output is written to crispr.gff3 (overwrite permission)
#-----------------------------------------------------------------------

sub findMatches {
	my ($onTargetLine) = @_;

	my @blastColumns = split( "\t", $onTargetLine );

	my (
	$queryId, $chrom, $identity, $length, $mismatches,
	$gaps,    $qStar, $qEnd,     $start,  $end
	) = @blastColumns;

	my $strand           = '+';
	my $offTargetMatches = 0;
	my $gffStart         = 0;
	my $gffEnd           = 0;
	
	if ( defined $offTarget{ $queryId } ) {
		$offTargetMatches = $offTarget{ $queryId };
	}
	
	if ( $start > $end ) {
		$strand   = '-';
		$gffStart = int $end;
		$gffEnd   = int $start;
	} else {
		$gffStart = int $start;
		$gffEnd   = int $end;
	}

	my @rowArray;
	@rowArray = (
		$chrom, ".", 'OLIGO', $gffStart, $gffEnd, ".", $strand, ".",
		"Name=$queryId; Note=$offTargetMatches off-target matches"
	);
	local $, = "\t";


	print GFF3 "@rowArray\n";
}
