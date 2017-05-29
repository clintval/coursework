#!/usr/bin/perl 
use warnings; 
use strict; 
 
my @GeneInfo1 = ('M65197.1','CFTR', 'Human cystic fibrosis (CFTR) gene'); 
 
my @GeneInfo2 = ( 
	'Eukaryota', 'Metazoa',     'Chordata',   
	'Craniata', 'Vertebrata',  'Euteleostomi', 
	'Mammalia', 'Eutheria',    'Euarchontoglires', 
	'Primates', 'Haplorrhini', 'Catarrhini', 
	'Hominidae', 'Homo' 
); 
#Combine the arrays 
my @CombinedGeneInfo = (@GeneInfo1,@GeneInfo2); 
 
print "@CombinedGeneInfo","\n";  
