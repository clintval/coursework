#!/usr/bin/perl
use warnings;
use strict;

my @filesToTest = qw(oddlyNamedGenes.txt notFile.txt zeroFile.txt nonWriteable.txt); 
 
print `ls -l *.txt`; #Show file permissions with ls ­l
 
 
foreach my $fileName (@filesToTest) 
{ 
	print $fileName, "\n"; 
	if (-e $fileName){ 
		print "\texists\n"; 
		if (-s $fileName){ 
			print "\thas non­zero size\n"; 
		}else{ 
			print "\thas zero size\n"; 
		} 
		if (-w $fileName){ 
			print "\tand is writeable\n"; 
		}else{ 
			print "\tand is not writeable\n";
		}
	}else{ 
		print "\tdoesn't exist\n"; 
	} 
}
