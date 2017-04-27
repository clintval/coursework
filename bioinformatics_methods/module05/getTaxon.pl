#!/usr/bin/perl
# Clint Valentine
# 10/29/2016

use strict;
use warnings;
use diagnostics;

use Bio::DB::EUtilities;

# Create an output file. $ENV{"HOME"} returns the home directory
my $OUTPUT_DIR = $ENV{"HOME"} . '/BIOL6309/module05/TAX_ID_XML_DATA';

unless ( -e $OUTPUT_DIR ) {
    `mkdir -p $OUTPUT_DIR`;
}

my @ids = qw(99883 45351 424395 3000000000);

foreach my $id ( @ids ) {
    my $factory = Bio::DB::EUtilities->new(
        -eutil => 'efetch',
        -db    => 'taxonomy',
        -id    => $id,
        -email => 'valentine.c@husky.neu.edu',
    );

    # Create an output file

    my $file = $OUTPUT_DIR . '/taxId.' . $id . '.xml';
    if ( -s $file ) { # Check if the output file exists with a non-zero size
                      # If so, no need to download,
        print STDERR "Data existed\n"
    } else {

        $factory->get_Response( -file => $file );
        print "Fetching the data from NCBI for taxid: ", $id, "\n";
        print $file, "\n";
        sleep(3); # Avoid spamming NCBI
    }
}
