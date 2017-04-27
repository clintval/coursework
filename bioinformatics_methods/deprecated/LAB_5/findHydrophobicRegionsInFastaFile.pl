#!/usr/bin/perl
use warnings;
use strict;

$/ = ">";

open INFILE, "<", "test.fasta" or die $!;
my @fastas = <INFILE>;
my ($i, $seq, $header);
my @data;
my ($countSeq, $countFind) = 0;
my $foundText = "Hydrophobic stretch was found in: ";

foreach (@fastas) {
	chomp;
	my $seq = $_;
	($header) = $seq =~ /.*(?=\;)/g;
	$data[$countSeq] = ([$header, $seq]);
	$countSeq++;
}

for ($i=0; $i<$countSeq; $i++){
	$_ = $data[$i][1];
	$header = $data[$i][0];
	if (m/[VILMFWCA]{8,}/){
		print $foundText, $header, "\n\n";
		$countFind++;
		while ($_ =~ /[VILMFWCA]{8,}/g){
			my $position = $-[0] - 1 - length($header);
			print ("$&\nThe match was at position: $position\n\n");
		}
	}
}

print "Hydrophibc regions(s) were found in $countFind sequences out of ", $countSeq - 1, " sequences.\n";
close INFILE;
