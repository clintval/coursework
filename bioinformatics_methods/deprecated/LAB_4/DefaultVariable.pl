#!/usr/bin/perl 
use warnings; 
use strict; 

my $DnaInfileName = 'DNAtest.fasta'; 

unless (open (INFILE, "<", $DnaInfileName ) ){ 
	die "Cannot open file " , $DnaInfileName , " " , $!; 
} 

while (<INFILE>) { 
	chomp; #always when reading 
	print; 	
	print "\n"; 
} 

close INFILE;
