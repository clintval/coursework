#!/usr/bin/perl 
use strict; 
use warnings; 
#get command line argument 
my $DnaInfileName = $ARGV[0]; 
 
#check for a file given 
if (! $DnaInfileName){ 
	die "You did not provide a input file with a DNA sequence"; 
}
 
unless ( open(INFILE, "<", $DnaInfileName) ) { 
	die "Cannot open file " , $DnaInfileName , " ", $!; 
 
} 
 
while (my $line = <INFILE>){ 
	chomp $line; 
	print $line , "\n"; 
} 
 
close INFILE;  
