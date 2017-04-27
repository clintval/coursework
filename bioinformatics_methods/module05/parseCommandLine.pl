#!/usr/bin/perl
# Clint Valentine
# 10/29/2016

use strict;
use warnings;
use diagnostics;

use Getopt::Long;
use Pod::Usage;

# GLOBALS
my $FILE   = '';
my $REPEAT = 0;
my $TEMP   = 0;
my $usage  = "\n\n$0 [options]\n
Options:
    -file        File to open
    -repeat      Number of times to repeat the experiment (int)
    -temp        Temperature to do the experiment (float)
    -help        Show this message

\n";

# Check the flags
GetOptions(
    'file=s'   => \$FILE,
    'repeat=i' => \$REPEAT,
    'temp=f'   => \$TEMP,
    help       => sub { pod2usage($usage); },
    )
    or pod2usage(2);

unless ( $FILE ) {
    die "Provide a file to open, -file <infile.txt>", $usage;
}

unless ( $REPEAT ) {
    die "How many times to repeat the experiment, -repeat 10", $usage;
}

unless ( $TEMP ) {
    die "Provide a temperature (Celsius) to run the experiment, -temp 68", $usage;
}
