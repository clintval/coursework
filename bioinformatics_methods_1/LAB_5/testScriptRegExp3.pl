#! /usr/bin/perl
use strict;
use warnings;
use feature qw(say);

my $accession;
my $gene;
my $dna;
my $proteinSeq;
my $oraganism;

my $infile = 'sampleGenbank.gb';
unless ( open( INFILE, "<", $infile ) ) {
	die "Can't open ", $infile, " for reading ", $!;
}
##get the entire file in the variable
$/ = '//';    #what does this do?
foreach my $genbankFileData (<INFILE>) {
	$accession  = getAccession($genbankFileData);
	$gene       = getVal( $genbankFileData, 'gene' );
	$dna        = getDnaSequence($genbankFileData);
	$proteinSeq = getVal( $genbankFileData, 'translation' );
	$oraganism  = getVal( $genbankFileData, 'organism' );

	if ( $accession ne 'error' ) {
		printResults( $accession,  "Accession" );
		printResults( $gene,       "Gene" );
		printResults( $dna,        "Dna" );
		printResults( $proteinSeq, "Protein" );
		printResults( $oraganism,  "Organism" );
	}
}
$/ = "\n";    #always set this back once you are done
close INFILE;

sub getAccession {
	my ($gbFile) = @_;
	if ( $gbFile =~ /ACCESSION\s*(\w+)/ ) {
		return $1;
	}
	else {
		return 'error';
	}
}

sub getDnaSequence {
	my ($gbFile) = @_;
	my $seq;
	if ( $gbFile =~ /ORIGIN\s*(.*)\/\//s ) {
		$seq = $1;
	}
	else {
		return "error";
	}
	$seq =~ s/[\s\d]//g;
	return uc($seq);
}

sub getVal {
	my ( $GB_file, $val ) = @_;
	my $found;
	if ( $GB_file =~ /$val="(.*?)"/s ) {
		$found = $1;
	}
	else {
		$found = 'unknown';
	}
	if ( $val eq 'translation' ) {
		$found =~ s/\s//g;
	}
	else { }
	return $found;

}

sub printResults {
	my ( $results, $type ) = @_;
	say $type , ": ", $results;
}
