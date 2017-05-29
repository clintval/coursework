#!/usr/bin/perl
# Clint Valentine
# 10/29/2016

use strict;
use warnings;
use diagnostics;

use Pod::Usage;
use Getopt::Long;
use Bio::DB::EUtilities;


# GLOBALS
my $GI_FILE     = '';
my $DB          = 'nr';
my $OUTPUT_FILE = '';
my $OVERWRITE   = 1;
my $usage       = "\n\n$0 [options]\n
Options:
    -file               File of GIs to open: GIs.txt
    -output_file        Output file: summary.txt
    -db                 BLAST Database <nr>
    -download_existing  Overwrite files already present? [default: 0] (int)
    -help               Show this message

\n";

# Check the flags.
GetOptions(
    'file=s'               => \$GI_FILE,
    'output_file=s'        => \$OUTPUT_FILE,
    'db=s'                 => \$DB,
    'download_existing=i'  => \$OVERWRITE,
    help                   => sub { pod2usage($usage); },
    )
    or pod2usage(2);

# Only two required arguments are GI_FILE and OUTPUT_FILE
unless ( $GI_FILE ) {
    die "Provide a file to open, -file <infile.txt>", $usage;
}
unless ( $OUTPUT_FILE ) {
    die "Provide a file to write to, -output_file <outfile.txt>", $usage;
}


# Open GI_FILE and populate array with GIs
open( INFILE, '<', $GI_FILE ) or
    die "Could not open file '$GI_FILE' $!";
my @GIs;
while ( <INFILE> ) {
    chomp;
    push @GIs, $_;
}
close INFILE;

# Open the output file and write a header
open( OUTFILE, '>', $OUTPUT_FILE) or
    die "Could not open file '$OUTPUT_FILE' $!";
print OUTFILE join "\t", 'GI', 'TAX_ID', 'COMMON_NAME', 'SCIENTIFIC_NAME',
    'LINEAGE', "\n";

# Loop through GIs and access all databases to get required information
foreach my $GI ( @GIs ) {

    if ( $GI !~ /\d+/ ) {
        print STDERR "This does not appear to be a valid GI ($GI), skipping\n";
        next;
    }

    # The next two commands call routines that query databases for metadata
    my ( $taxId, $commonName, $scientificName ) = getTaxidFromGiBlastDbCmd($GI, $DB);
    my $lineage = getLineageFromTaxId( $taxId, $OVERWRITE );
    # Write all information out to outfile
    print OUTFILE join "\t", $GI, $taxId, $commonName, $scientificName, $lineage;
    print join "\t", $GI, $taxId, $commonName, $scientificName, $lineage;
}
close OUTFILE;


sub getTaxidFromGiBlastDbCmd {
    my ( $gi, $db ) = @_;

    # Create a command for querying the BLASTDB of specification
    my $exec =
        "blastdbcmd -db " . $db
        . " -entry "
        . $gi
        . ' -outfmt "NCBI Taxonomy id: %T; Common name: %L; Scientific name: %S" -target_only | ';
    # Print to STDERR the command that is being used and then call the command
    print STDERR "Command: $exec\n\n";
    unless ( open( SYSCALL, $exec ) ) {
        die "Can't open the SYSYCALL", $!;
    }

    # Initialize metadata as "N/A"
    my ( $taxId, $commonName, $scientificName ) = ( "N/A", "N/A", "N/A" );

    # Use regex to filter out the proper information for each metadata
    while (<SYSCALL>) {
        chomp;
        if ( $_ =~ /NCBI taxonomy id:.*\s+(\d+)/i ) {
            $taxId = $1
        }
        if ( $_ =~ /Common name:\s+(.*)?;/i ) {
            $commonName = $1
        }
        if ( $_ =~ /Scientific name:\s+(.*)/i ) {
            $scientificName = $1
        }
    }
    close SYSCALL;

    return ( $taxId, $commonName, $scientificName );

}

sub getLineageFromTaxId {
    my ( $taxId, $OVERWRITE ) = @_;

    # Instantiate a EUtilities class
    my $factory = Bio::DB::EUtilities->new(
        -eutil => 'efetch',
        -db    => 'taxonomy',
        -id    => $taxId,
        -email => 'valentine.c@husky.neu.edu',
    );

    # Create output directories if they do not exist.
    my $OUTPUT_DIR = './TAX_ID_XML_DATA';
    unless ( -e $OUTPUT_DIR ) {
        `mkdir -p $OUTPUT_DIR`;
    }

    # Create output file name and directory
    my $XMLfile = $OUTPUT_DIR . '/taxId.' . $taxId . '.xml';

    # Check if the output file exists with a non-zero size and $OVERWRITE == 0
    if ( -s $XMLfile && $OVERWRITE == 0 ) {
        print STDERR "Data existed for taxid: $taxId\n\t$XMLfile\n"
    } else {
        $factory->get_Response( -file => $XMLfile );
        print "Fetching the data from NCBI for taxid: $taxId\n\t$XMLfile\n\n";
        sleep(3); # Avoid spamming NCBI
    };

    # Change record separator to undefined for pulling in XML into string
    local $/;
    open( INFILE, '<', $XMLfile ) or
        die "Could not open file '$XMLfile' $!";
    my $XML = <INFILE>;
    close INFILE;

    $XML  =~ /<Lineage>(.*)<\/Lineage>/ig;
    return $1 // 'N/A'
}
