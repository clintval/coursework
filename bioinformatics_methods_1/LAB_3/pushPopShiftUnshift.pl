#!/usr/bin/perl
use warnings;
use strict;

my @aminoAcidsInThisProtein = qw/Ser Pro Thr Ala/;
print "@aminoAcidsInThisProtein", "\n";

# Take the first AA and assign to $aminoAcid
my $aminoAcid = shift @aminoAcidsInThisProtein;

# Output is Ser
print $aminoAcid, "\n";

# Output is Pro, Thr, Ala
print "@aminoAcidsInThisProtein", "\n";

# Take the last AA and assign to $aminoAcid
$aminoAcid = pop @aminoAcidsInThisProtein;

# Output is Ala
print $aminoAcid;

# Output is Pro, Thr
print "@aminoAcidsInThisProtein", "\n";

# Array now contains Pro Thr His
push (@aminoAcidsInThisProtein, 'His');

# Output is Pro Thr His
print "@aminoAcidsInThisProtein", "\n";

# Array now contains Arg Pro Thr His
unshift (@aminoAcidsInThisProtein, 'Arg');

# Output is Arg Pro Thr His
print "@aminoAcidsInThisProtein", "\n";
