#!/usr/bin/perl
# Modified by Clint Valentine
# January 26th 2017
use warnings;
use strict;

printReport();

# Load the GO terms and GO descriptions to a hash for lookup.
sub readGoDesc {
	my %goDesc;

	local $/ = "[Term]";

	# Open a filehandle for the GO_DESC file.
	open( GO_DESC, "<", "/scratch/go-basic.obo" ) or die $!;

	# Read the gene-to-description file line-by-line
	while (<GO_DESC>) {
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
				if ( $keyValuePair[0] =~ /^id/ ) {
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
	return \%goDesc;
}

# Load the transcript and protein IDs from BLAST output to a hash for lookup.
sub readBlast {
	my %transcriptToProtein;

	# Open a filehandle for the BLAST file.
	open( BLAST, "<", "/scratch/RNASeq/blastp.outfmt6" ) or die $!;

	while (<BLAST>) {
		chomp;

		# Split the line on tabs and assign results to named variables.
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

		if ( $pident > 99 ) {
			if ( not defined $transcriptToProtein{$transcriptId} ){
					$transcriptToProtein{$transcriptId} = $swissProtBase;
			}
		}
	}
	return \%transcriptToProtein;
}

#Load the protein IDs and corresponding GO terms to a hash for lookup.
sub readGeneToGO {
	# Hash to store gene to GO term mappings
	my %geneToGO;

	# Hash to store gene to GO term descriptions
	my $goDesc = readGoDesc();

	# Open a filehandle for the gene ID to GO Term.
	open( GENE_TO_GO, "<", "/scratch/gene_association_subset.txt" ) or die $!;

	while (<GENE_TO_GO>) {
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
			$geneToGO{$DB_Object_ID}{$GO_ID} = $goDesc->{$GO_ID} // "NA";
		}
	}
	return \%geneToGO;
}

# Loop through the differential expression file, and lookup the protein ID,
# GO term, GO term description, and SwissProt protein description then print
# the output.
sub printReport {
	my $geneToGO = readGeneToGO();
	my $transcriptToProtein = readBlast();

	# Open a filehandle for the CUFFDIFF file.
	open( DIFF_EXP, "<", "/scratch/RNASeq/diffExpr.P1e-3_C2.matrix" ) or die $!;

	# Open a filehandle to write the report.
	open( REPORT, ">", "report3.txt" ) or die $!;

	while (<DIFF_EXP>) {
		chomp;

		my ($transcriptId, $Sp_ds, $Sp_hs, $Sp_log, $Sp_plat ) = split( /\t/, $_ );

		my $proteinCounter  = 0;
		my $proteinId   = "NA";
		my $proteinDesc = "NA";

		# Lookup protein ID.
		if ( defined $transcriptToProtein->{$transcriptId} ) {
			$proteinId   = $transcriptToProtein->{$transcriptId};
			$proteinDesc = getProteinInfoFromBlastDb($proteinId);
		}

		# Lookup GO Term and GO Description
		if ( defined $geneToGO->{$proteinId} ) {
			# Loop through GO IDs and print according to assignment
			foreach my $GO_ID ( keys $geneToGO->{$proteinId} ) {

				# Keep track of how many GO IDs this protein ID has
				$proteinCounter++;

				# Access the multi-dimensional hash reference
				my $GO_DESC = $geneToGO->{$proteinId}->{$GO_ID};

				# If this is the first entry for a protein ID, print everything
				# If not, print only the information that has changed.
				if ( $proteinCounter > 1 ) {
					print REPORT join("\t",
						" ", " ", " ", " ", " ", " ", " ", $GO_ID, $GO_DESC), "\n";
				} else {
					print REPORT join("\t",
						$transcriptId, $Sp_ds, $Sp_hs, $Sp_log, $Sp_plat,
						$proteinId, $GO_ID, $GO_DESC, $proteinDesc), "\n";
				}
			}
		}
	}
}

# Get the protein description from BLAST DB.
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
