#!/usr/bin/perl 
use warnings; 
use strict; 

#Initialize a Hash 
my %french = ( 
        apple => "pomme", 
        pear => "poivre", 
        orange => "Leon Brocard", 
	banana => "banane" 
);

print "-" x50, "\n"; 

#Sort hash by keys 
foreach my $key (sort (keys %french)){ 
print $key, "\t", $french{$key}, "\n" x2; } 
print "-" x50, "\n"; 

#Sort hash by values 
foreach my $value (sort {$b cmp $a} (values %french)){ 
	print $value, "\n" x2; 
} 
print "-" x50, "\n"; 

#Case­insensitive sort hash by values 
foreach (sort {"\L$b" cmp "\L$a"} (values %french)){ 
	print $_, "\n" x2; 
}
