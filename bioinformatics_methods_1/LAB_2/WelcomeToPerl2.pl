#!/usr/bin/perl
use warnings;
use strict;

my $version = "5.10.1";
my $name = "Clint";
my $welcome1 = "Welcome to Perl $version (single-quoted)";
my $welcome2 = 'Welcome to Perl $version (double-quoted)';
print $welcome1, " ", $name, "\n";
print $welcome2, " ", $name, "\n";
