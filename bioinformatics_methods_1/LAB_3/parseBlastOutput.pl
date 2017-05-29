#!usr/bin/perl
use warnings;
use strict;

# Path Input
my $blastInputFile = '/scratch/SampleDataFiles/sampleBlastOutput.txt';

# Path Output
my $blastRewriteFile = 'firstThreeBlastColumns.txt';

# Open as Handle (Don't forget to close!)
open (BLAST, "<", $blastInputFile) || die "Can't open $blastInputFile: $!";

# Open Read Out File (Don't forget to close!)
open (BLAST_REWRITE, ">", $blastRewriteFile) || die "Can't open $blastRewriteFile: $!";

# Read line by line
while (<BLAST>){ 
	chomp; 
	my @blastFieldArray = split();
	my $percentIdentity = $blastFieldArray[2];
	if ($percentIdentity > 75){
		for (my $i = 0; $i <= 2; $i++){
			print BLAST_REWRITE $blastFieldArray[$i], "\t";
			print STDOUT $blastFieldArray[$i], "\t";
		}
		print BLAST_REWRITE "\n";	
	}
}  
close(BLAST_REWRITE);
close(BLAST);
