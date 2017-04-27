#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my %master = ();
my %GOHash = ();

my $flyReferenceFile = '/scratch/Drosophila/fb_synonym_fb_2014_05.tsv';
my $flyOntologyFile  = '/scratch/Drosophila/FlyRNAi_data_baseline_vs_EGF.txt';
my $flyAssociation   = '/scratch/Drosophila/gene_association.goa_fly';
my $flySymbolFile    = 'FlyRNAi_data_baseline_vs_EGFSymbol.txt';
my $flyGOFile        = 'FlyRNAi_data_baseline_vs_EGF_GO.txt';

open(REF,      "<",  $flyReferenceFile) or die $!;
open(BASELINE, "<",  $flyOntologyFile) or die $!;
open(LOOKUP,   "<",  $flyAssociation) or die $!;
open(BYSYMBOL, ">",  $flySymbolFile) or die $!;
open(BYGOTERM, ">",  $flyGOFile) or die $!;

print `clear`, <<"OUT";
Reading $flyReferenceFile:
Loading FBgn IDs and Gene Symbols...
OUT

while ( <REF> ) {
	my @row = split( /\t/ );
	if ( @row && $row[0] =~ /(^FBgn\d+)/ig ) {
		$master{ $row[0] } = $row[1];
	}
}

print `clear`, <<"OUT";
Reading $flyOntologyFile:
Loading Gene Symbol & EGF baseline and stimulus data...
Printing $flySymbolFile with Gene Symbol & EGF data...
OUT

print BYSYMBOL "!Gene Symbol\tEGF_Baseline\tEGF_Stimulus\n";

while ( <BASELINE> ) {
	chomp;
	my @row = split( /\t/ );
	if ( @row && exists $master{ $row[0] } ) {
		print BYSYMBOL "$master{ $row[0] }\t$row[1]\t$row[2]\n";
	}
}

close BYSYMBOL;	# Close write only

print `clear`, <<"OUT";
Reading $flyAssociation:
Loading Gene Symbol and GO terms...
OUT

while ( <LOOKUP> ) {
	chomp;
	next if ($_ =~ m/^[!]/ );
	my @row = split( /\t/ );
	if ( @row ) {
		$GOHash{ $row[2] } = $row[4];
	}
}

# Uncomment to check condition of hashes
# print Dumper(\%GOHash);
# print Dumper(\%master);

print `clear`, <<"OUT";
Reading $flySymbolFile:
Printing $flyGOFile with GO term & EGF data...
OUT

open (BYSYMBOL, "<", $flySymbolFile) or die $!; # Open read only

print BYGOTERM "!GO Term\tEGF_Baseline\tEGF_Stumulus\n";

while ( <BYSYMBOL> ) {
	chomp;
	next if ($_ =~ m/^[!]/ );
	my @row = split( /\t/ );
	if ( @row && exists $GOHash{ $row[0] } ) {
		print BYGOTERM "$GOHash{ $row[0] }\t$row[1]\t$row[2]\n";
	}
}

close REF;
close BASELINE;
close LOOKUP;
close BYSYMBOL;
close BYGOTERM;

print `clear`, "convertDataToGeneSymbol.pl successful.\n";
