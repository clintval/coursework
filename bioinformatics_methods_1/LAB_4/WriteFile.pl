#!/usr/bin/perl
use warnings;
use strict;

unless (open(GENE_LIST, ">", "oddlyNamedGenes.txt") ) {
	die "Cannot open file ", $!;
}

my @genes = qw(dissatisfaction nerd fruitless turnip);

foreach my $gene (@genes) {
	print GENE_LIST $gene, "\n";
}

close GENE_LIST;

foreach (`tail oddlyNamedGenes.txt`){
	chomp;
	my $lineOfOutput = $_;
	print $lineOfOutput, "\n";
}
