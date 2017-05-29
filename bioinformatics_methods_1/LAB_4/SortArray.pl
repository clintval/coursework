#!/usr/bin/perl 
use warnings; 
use strict; 

my @tackyShows = ("Myrtle Manor", "Strange Addiction", 
"Worst Tattoos"); 
my @grades = (100, 95, 88, 100); 
sort (@grades); #Useless sort 

print "@grades\n\n"; 

#Default sort ascending ASCII 
@grades = sort (@grades); #Useful sort 
 
print "@grades\n\n"; #Sort ascending numeric 
@grades = sort {$a <=> $b} (@grades); 
print "@grades\n\n"; 

#Sort descending ASCII  
@tackyShows = sort {$b cmp $a} (@tackyShows); 
print join("\n\n", @tackyShows),"\n";  
