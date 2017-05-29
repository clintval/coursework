#!/usr/bin/perl
# Clint Valentine
# January 31 2017
use warnings;
use strict;
use GO;

my %goTerms;

# Instantiate one GO object with random information
my $go = GO->new(
    id => 'GO:0000002',
    name => 'mitochondrial genome maintenance',
    namespace => 'biological_process',
    def => 'The maintenance of the structure and integrity of the mitochondrial genome; includes replication and segregation of the mitochondrial chromosome.',
    is_a => 'GO:0007005 ! mitochondrion organization',
    );

# Test the GO class by printing all instantiated attributes
print join "\n",
    $go->id(),
    $go->name(),
    $go->namespace(),
    $go->def(),
    $go->is_a() . "\n";

# Assign GO object to goTerms.
$goTerms{$go->id()} = $go;

