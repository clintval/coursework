#!/usr/bin/perl
use warnings;
use strict;

#Assign the path to the BLAST file to $blastOutputFile  
my $blastOutputFile = '/scratch/SampleDataFiles/sampleBlastOutput.txt'; 
#Assign the path to the file to which BLAST will be written to 

my $blastRewriteFile = 'blastRewrite.txt'; 
#Open file for reading. "<" means for reading. 
open (BLAST,"<",$blastOutputFile) or die $!; 
#Open file for writing. ">" means for writing. 
open (BLAST_REWRITE,">",$blastRewriteFile) or die $!; 
#Keep looping while there are lines left to read 
while (<BLAST>){ 
	chomp; 
	#Copy line from the default variable $_ to a named variable 
	my $blastLine = $_; 
	print BLAST_REWRITE $blastLine,"\n"; 
	#print STDOUT $blastLine,"\n"; 
}  
close(BLAST_REWRITE); 
close(BLAST);
