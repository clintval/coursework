#!/usr/bin/perl
use warnings;
use strict;

#Author: C Roesel
#Creation Date: November 15 2013
#Edits: C Valentine

#This program executes BLAST and parses the output in a single step.
#This can be useful when you will need to convert the BLAST output to
#another format. If for example you expect to produce 20G BLAST
#output, then reformat that output to another 20G file in a different
#format, you avoid having to use 20G disk space for a temporary file.

unless ( open( GFF3, ">", 'crispr.gff3' ) ) {
	die $!;
}

unless ( open( OFFTARGET, ">", 'offTarget.txt' ) ) {
	die $!;
}

blastOligos();

sub blastOligos {

#Put my BLAST command and all the params in an array. This could be created as
#a single string, but an array makes it easier to see the individual
#parameters.
  my @commandAndParams = (
      'blastn', '-task blastn',
      '-db Drosophila2L',
      '-query uniqueKmersEndingGG.fasta',
      '-outfmt 6'
  );

  #Print the BLAST command for debugging purposes.
  print `clear`, "@commandAndParams\n";

  #Run the BLAST command and get the output as a filehandle named BLAST.
  open( BLAST, "@commandAndParams |" );

  #Process the BLAST output line-by-line using the filehandle BLAST.
  while (<BLAST>) {

      #Get rid of end-of-line characters.
      chomp;

   #Assign the line of output from the default variable $_ to the meaningfully
   #named variable blastOutputLine.
      my $blastOutputLine = $_;
      processBlastOutputLine($blastOutputLine);
  }
}

sub processBlastOutputLine {
	my ($blastOutputLine) = @_;
	#If the output line isn't a comment line
	if ( $blastOutputLine !~ /^#/ ) {

		#Split the output line using the tab as separator.
		my @blastColumns = split( "\t", $blastOutputLine );

		#Assign the column positions to meaningfully named variables.
		my (
		$queryId, $chrom, $identity, $length, $mismatches,
		$gaps,    $qStar, $qEnd,     $start,  $end
		) = @blastColumns;
		print $blastOutputLine;		
		if ( $identity < 100.00) {
			print OFFTARGET "$blastOutputLine\n";
		}

		my $strand   = '+';
		my $gffStart = 0;
		my $gffEnd   = 0;
		if ( $start > $end ) {
			$strand   = '-';
			$gffStart = int $end;
			$gffEnd   = int $start;
		} else {
			 $gffStart = int $start;
			$gffEnd   = int $end;
		}
		my @rowArray;
		@rowArray = (
			$chrom, ".", 'OLIGO', $gffStart, $gffEnd, ".", $strand, ".",
			"Name=$queryId;Note=Some info on this oligo"
		);
		local $, = "\t";
		
		if ( $identity == 100.00 ) {
			print GFF3 "@rowArray\n";
		}
	}
}

print "\nComplete.\n";
close GFF3;
close OFFTARGET;
