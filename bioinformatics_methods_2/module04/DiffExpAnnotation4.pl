#!/usr/bin/perl
use warnings;
use strict;

use BLAST2;
use GO2;
use Matrix;
use Report;

printReport();

sub readGoDesc {
	# Load the GO objects to a hash for lookup.
	$_ = '';
	local $/ = /\[Term\]|\[Typedef\]/;

	open( GO_DESC, '<', '/scratch/go-basic.obo' ) or die $!;

	my %goObjs;
	while (<GO_DESC>) {
		next if $. < 2;
		chomp;

		my $goObj = GO->new({ longGoDesc => $_ });

		if ( $goObj->has_id() ) {
			$goObjs{$goObj->get_id()} = $goObj;
		}
	}

	return \%goObjs;
}

sub readBlast {
	# Load the BLAST objects passing filter to a hash.
	my %transcriptToProtein;

	open( BLASTOUT, "<", "/scratch/RNASeq/blastp.outfmt6" ) or die $!;

	while (<BLASTOUT>) {
		chomp;

		my $blastObj = BLAST->new({ blastLine => $_ });

		# Filter BLAST lines if there is percent identiy greater than 99%.
		if ( $blastObj->has_pident() && $blastObj->get_pident > 99 ) {
			if ( not defined $transcriptToProtein{$blastObj->get_transcriptId()} ){
					$transcriptToProtein{$blastObj->get_transcriptId()} = $blastObj->get_swissProtBase();
			}
		}
	}
	close BLASTOUT;
	return \%transcriptToProtein;
}

#Load the protein IDs and corresponding GO terms to a hash.
sub readGeneToGO {
	# Hash to store gene to GO term mappings
	my %geneToGO;

	# Hash to store gene to GO term descriptions
	my $goObjs = readGoDesc();

#	foreach my $key (keys %$goObjs) {
#		print $key . " == " . $goObjs->{$key}->get_id() . "\n";
# }

	# Open a filehandle for the gene ID to GO Term.
	open( GENE_TO_GO, "<", "/scratch/gene_association_subset.txt" ) or die $!;

	while (<GENE_TO_GO>) {
		chomp;

		my ( $DB, $DB_Object_ID, $DB_Object_Symbol, $Qualifier, $GO_ID ) =
			split( "\t", $_ );

		# Make sure there is something in element 1 of the array
		# before using it as the key to a hash.
		if ( defined $DB_Object_ID && defined $GO_ID && defined $goObjs->{$GO_ID} ) {
			#print $goObjs->{$GO_ID}->get_id();

			# Store the GO Object that matches this protein ID into the hash.
			$geneToGO{$DB_Object_ID}{$GO_ID} = $goObjs->{$GO_ID} // "NA";
		}
	}
	close GENE_TO_GO;
	return \%geneToGO;
}

sub printReport {
	my $geneToGO = readGeneToGO();
	my $transcriptToProtein = readBlast();

	# Open a filehandle for the CUFFDIFF file.
	open( DIFF_EXP, '<', '/scratch/RNASeq/diffExpr.P1e-3_C2.matrix' ) or die $!;

	while (<DIFF_EXP>) {
		next if $. < 2;
		chomp;

		my $matrix = Matrix->new({ expressionLine => $_ });

		my @goObjs;
		my $proteinId   = "NA";
		my $proteinDesc = "NA";

		# Lookup protein ID.
		if ( defined $transcriptToProtein->{$matrix->get_transcript_id} ) {
			$proteinId   = $transcriptToProtein->{$matrix->get_transcript_id};
			$proteinDesc = getProteinInfoFromBlastDb($proteinId);
		};


		# Lookup GO Term and GO Description
		if ( defined $geneToGO->{$proteinId} ) {
			# Loop through GO IDs and print according to assignment
			foreach my $GO_ID ( keys $geneToGO->{$proteinId} ) {
				# Access the multi-dimensional hash reference
				push @goObjs, $geneToGO->{$proteinId}->{$GO_ID};
			}
		}

		my $report = Report->new({
				goTerms     => \@goObjs,
				matrix      => $matrix,
				proteinId   => $proteinId ,
				proteinDesc => $proteinDesc,
			}
		);

		$report->printAll();
	}
	close DIFF_EXP;
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
