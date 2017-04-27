#!/usr/bin/perl 
use warnings; 
use strict; 

print "Default Return: ", defaultReturn("ATGCU"), "\n"; 

sub defaultReturn { 
	my ($sequence) = @_; 
	my $revcom = reverse $sequence; 
} 
 
my ($reverseComplement, $seqLength) = reverseComplementUC("gatgccaggccaaggtggagcaagcggtgg"); 
print "Length: ", $seqLength, "\tRev. Comp: ", $reverseComplement, "\n"; 
 
# Based on revcom from Beginning Perl for Bioinformatics 
sub reverseComplementUC { 
	my ($sequence) = @_;
	my $revcom = reverse $sequence; 
	$revcom =~ tr/ACGTacgt/TGCAtgca/; 
 	my $length = length $revcom; 
	return ("\U$revcom", $length); 
}
