#! /usr/bin/perl
use warnings;
use strict;

my $geneToGoFile = "/scratch/gene_association_subset.txt";
my $blastFile    = "/scratch/RNASeq/blastp.outfmt6";
my $diffExpFile  = "/scratch/RNASeq/diffExpr.P1e-3_C2.matrix";
my $goDescFile   = "/scratch/go-basic.obo";
my $reportFile   = "reportWithBugs.txt";
my $goDescShort  = "goDesc.txt";

# Open a filehandle for the gene ID to GO Term.
open( GENE_TO_GO, "<", $geneToGoFile ) or die $!;

# Open a filehandle for the BLAST file.
open( BLAST, "<", $blastFile ) or die $!;

# Open a filehandle for the CUFFDIFF file.
open( DIFF_EXP, "<", $diffExpFile ) or die $!;

# Open a filehandle for the GO_DESC file.
open( GO_DESC, "<", $goDescFile ) or die $!;

# Open a filehandle to write the report.
open( REPORT, ">", $reportFile ) or die $!;

# Hash to store gene-to-description mappings
my %geneToDescription;

# Hash to store gene to GO term mappings
my %geneToGo;

# Hash to store gene to GO term descriptions
my %goDesc;

# Hash to store BLAST mappings
my %transcriptToProtein;

readGoDesc();
readBlast();
readGeneToGO();
printReport();

#Load the transcript IDs and protein IDs from the BLAST output to a hash for lookup.
sub readBlast {
	while (<BLAST>) {

		# Remove end-of-line characters
		chomp;

		# Split the line on tabs and assign results
		# to named variables.
		my (
			$qseqid, $sseqid, $pident, $length, $mismatch, $gapopen,
			$qstart, $qend,   $sstart, $send,   $evalue,   $bitscore
		  )
		  = split( /\t/, $_ );
		my ( $transcriptId, $isoform ) = split( /\|/, $qseqid );
		my ( $giType, $gi, $swissProtType, $swissProtId, $proteinId ) =
		  split( /\|/, $sseqid );
		my ( $swissProtBase, $swissProtVersion ) =
		  split( /\./, $swissProtId );
		$transcriptToProtein{$transcriptId} = $swissProtBase;

	}
}

#Load the protein IDs and corresponding GO terms to a hash for lookup.
sub readGeneToGO {
	while (<GENE_TO_GO>) {

		# Remove end-of-line characters
		chomp;
		my ( $DB, $DB_Object_ID, $DB_Object_Symbol, $Qualifier, $GO_ID ) =
		  split( "\t", $_ );

		# Make sure there is something in element 1 of the array
		# before using it as the key to a hash.
		if ( defined $DB_Object_ID && defined $GO_ID ) {

			# Put the gene ID and GO term in the hash with
			# both acting as keys to create a multi-dimensional hash.
			# There can be more than one GO term per gene, but the
			# mapping file also lists some GO terms twice. To store
			# multiple GO terms per gene without storing duplicates,
			# use a hash of hashes.
			if ( not defined $geneToGo{$DB_Object_ID} ) {
				$geneToGo{$DB_Object_ID} = $GO_ID;
			}
		}
	}
}

#Load the GO terms and GO descriptions to a hash for lookup.
sub readGoDesc {
	local $/ = "[Term]";

	# Read the gene-to-description file line-by-line
	while (<GO_DESC>) {

		# Remove end-of-line characters
		chomp;

		# Split the line on tabs and assign results
		# to an array.
		my $longGoDesc = $_;
		my @fields = split( "\n", $_ );
		my $id;
		my $name;
		foreach my $field (@fields) {
			my @keyValuePair = split( ": ", $field );
			if ( defined $keyValuePair[0] ) {
				if ( $keyValuePair[0] =~ /id$/ ) {
					$id = $keyValuePair[1];
				}
				elsif ( $keyValuePair[0] =~ /name$/ ) {
					$name = $keyValuePair[1];
				}
			}
		}
		if ( $name && $id ) {
			$goDesc{$id} = $name;
		}
	}

}

#Loop through the differential expression file, and lookup the protein ID, GO term, GO term description,
#and SwissProt protein description then print the output.
sub printReport {
	while (<DIFF_EXP>) {
		chomp;
		my ($transcriptId, $Sp_ds, $Sp_hs, $Sp_log, $Sp_plat ) = split( /\t/, $_ );
		my $proteinId   = "NA";
		my $GO_ID       = "NA";
		my $GO_Desc     = "NA";
		my $proteinDesc = "NA";

		#Lookup protein ID.
		if ( defined $transcriptToProtein{$transcriptId} ) {
			$proteinId   = $transcriptToProtein{$transcriptId};
			$proteinDesc = getProteinInfoFromBlastDb($proteinId);

			#Lookup GO Term.
			if ( defined $geneToGo{$proteinId} ) {
				$GO_ID = $geneToGo{$proteinId};

				#Lookup GO term description.
				if ( defined $goDesc{$GO_ID} ) {
					$GO_Desc = $goDesc{$GO_ID};
				}
			}
		}
		my $line = join( "\t",
			$transcriptId, $proteinId, $GO_ID, $Sp_ds, $Sp_hs, $Sp_log, $Sp_plat, $GO_Desc,
			$proteinDesc );
		print REPORT $line, "\n";
	}
}

#Get the protein description from BLAST DB.
sub getProteinInfoFromBlastDb {
	my ($proteinId) = @_;
	my $db          = '/blastDB/swissprot';
	my $exec        =
	    "blastdbcmd -db " . $db
	  . " -entry "
	  . $proteinId
	  . ' -outfmt "%t" -target_only | ';
	unless ( open( SYSCALL, $exec ) ) {
		die "Can't open the SYSCALL ", $!;
	}
	my $proteinDescription = 'NA';
	while (<SYSCALL>) {
		chomp;
		if ( $_ =~ /RecName:\s+(.*)/i ) {
			$proteinDescription = $1;
		}
	}
	close SYSCALL;
	return $proteinDescription;
}

