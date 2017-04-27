#!/usr/bin/perl
use strict;
use warnings;

$/ = ">";

my $count = 0;
my $motif = 'TCCCTGGAAGC';
my $reference_genome = 'dmel-all-chromosome-r6.02.fasta';

my $filename = "/scratch/Drosophila/$reference_genome";
my $regex = qr/($motif)/x;

open(INFILE, "<", $filename) or die $!;

while ( my $line = <INFILE> ) {
	$line =~ s/\n\s*//g;
	&findTFBS( $line );
}

sub findTFBS {
	my @groups = $_[0] =~ m/$regex/ig;
	foreach( @groups ) {
		$count += 1;
		# print "\n\t$_\n" if $_;	# If you wanted to see them all?
	}
}

print `clear`, <<"OUT";
Found $count potential transcription factor binding sites
that match $motif in $reference_genome
OUT

close INFILE;
