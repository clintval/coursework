#!/usr/bin/perl 
use warnings; 
#use strict; 
 
 
 
sub nameLastFirst { 
	my ($first, $last) = @_; 
	my $lastNameLength = length($last);
	print $lastNameLength, "\t",$last, ", ", $first,"\n"; 
} 
nameLastFirst("Rosalind", "Franklin"); 
nameLastFirst("Margaret", "Dayhoff"); 
nameLastFirst("Barbara", "McClintock"); 

print $lastNameLength
