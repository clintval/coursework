#!/usr/bin/perl
use warnings;
use strict;

unless (open(REAGENTS, "<", "amplicons.fasta")){
	die "Unable to open fasta file!", $!;
}

findPattern("(CA[AGTC]){6,}");
 

sub findPattern {
    my ($pattern) = @_;
    local $/ = ">";
    while (<REAGENTS>){
    chomp;
    my $reagent = $_;
    my $reagentId = "NA";
    if ($reagent =~ /(DRSC\d*)/){
    $reagentId = $1;
    }
    if($reagent =~ /($pattern)/){
    print $reagentId, "\n",$1, "\n";
    }
    }
}
