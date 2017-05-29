#!/usr/bin/perl
# Clint Valentine
# January 31 2017
use warnings;
use strict;
use GO;

my $goObjects = readGo();

# Load the GO terms and GO descriptions to a hash for lookup.
sub readGo {
	my %goObjects;

	local $/ = "[Term]";

	# Open a filehandle for the GO_DESC file.
	open( GO_DESC, "<", "/scratch/go-basic.obo" ) or die $!;

	# Read the gene-to-description file line-by-line
	while (<GO_DESC>) {
		chomp;

		# Split the line on tabs and assign results to an array.
		my $longGoDesc = $_;
		my @fields = split( "\n", $_ );
		my $id;
		my $name;
		foreach my $field (@fields) {
			my @keyValuePair = split( ": ", $field );
			if ( defined $keyValuePair[0] ) {
				print $keyValuePair[0] . "\n";
				print $keyValuePair[1] . "\t\n";
				if ( $keyValuePair[0] =~ /^id/ ) {
					$id = $keyValuePair[1];
				}
				elsif ( $keyValuePair[0] =~ /name$/ ) {
					$name = $keyValuePair[1];
				}
			}
		}
		if ( $name && $id ) {
			my $go = GO->new(id => $id, name => $name);
			$goObjects{$go->id()} = $go;
		}
	}
	return \%goObjects;
}
