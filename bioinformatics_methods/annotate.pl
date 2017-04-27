#!/usr/bin/perl
use warnings;
use strict;

#Open the blastx output file for reading.
my $edgeDir = 'edgeR.20134.dir';
open( BLAST_OUT, '<', 'blastp.outfmt6' ) or die $!;
opendir( DE_FILES, 'edgeR.20134.dir' );

my %transcriptToSwissProt;

while (<BLAST_OUT>) {

	#Split the blastx fields on tabs
	my @fields = split( '\t', $_ );

	#Get the transcript ID
	my $transcriptId = $fields[0];

	#Get the subject ID
	my $subjectId = $fields[1];

	#Split the subject ID on pipe
	my @subjectIds = split( '\|', $subjectId );

	#Get the swissProt ID
	my $swissProtId = $subjectIds[3];
	#Check if in hash already
	if ( not defined $transcriptToSwissProt{$transcriptId} ) {
		#Add to hash
		$transcriptToSwissProt{$transcriptId} = $swissProtId;
	}
}
#Close BLAST filehandle
close(BLAST_OUT);
#Read edgeR directory
while ( readdir DE_FILES ) {
	chomp;
	#Check if this is a results file
	if ( $_ =~ /results$/ ) {
		#Build filenames
		my $deFile        = $edgeDir . '/' . $_;
		print $deFile,"\n";
		my $annotatedFile = $deFile . '.annotated';
		#Open filehandles for writing
		open( DE_FILE, '<', $deFile )        or die $!;
		open( ANNOT,   '>', $annotatedFile ) or die $!;
		#Read file line-by-line
		while (<DE_FILE>) {
			chomp;
			#Store line as variable since $_ can get overwritten by other operations
			my $line = $_;
			#Set the default value for SwissProt ID
			my $swissProt = 'NA';
			#Split DE line on tabs
			my @fields = split('\t', $_);
			#Get the transcriptId
			my $transcriptId = $fields[0];
			#Check if in hash
			if(defined $transcriptToSwissProt{$transcriptId}){
				#Get SwissProtId
				$swissProt = $transcriptToSwissProt{$transcriptId};
			}
			print ANNOT $swissProt,"\t", $line, "\n";
			
		}
		#Close filehandles
		close(DE_FILE);
		close(ANNOT);
	}
}
