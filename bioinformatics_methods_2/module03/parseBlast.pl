#!/usr/bin/perl
# Clint Valentine
# January 30 2017
use warnings;
use strict;
use BLAST;
use autobox;

my $records = readBlast();

# Loop through records and print them
foreach my $id ( sort keys $records ) {
	$records->{$id}->printAll();
}

sub readBlast {
	my %parsedBlast;

	# Open a filehandle for the BLAST file.
	open( INFILE, '<', '/scratch/RNASeq/blastp.outfmt6' ) or die $!;

	while (<INFILE>) {
		chomp;

		# Instantiate a new BLAST object and fill it with fields from this line.
		my $blastObj = BLAST->new();
		$blastObj->parseBlastLine($_);

		# Add this BLAST record object to the hash.
		$parsedBlast{$blastObj->transcriptId()} = $blastObj;
	}
	close(INFILE);
	return \%parsedBlast;
}
