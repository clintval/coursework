#!/usr/bin/perl
use warnings;
use strict;

my @apples = qw(Braeburn Fuji Gala);
my @oranges = qw(Mandarin Valencia Navel);

passByValue (@apples, @oranges);

sub passByValue {
	my @params = @_;
	foreach my $param (@params){
		print $param, "\n";
	}
}

passByReference (\@apples, \@oranges);

sub passByReference {
	my ($apples, $oranges) = @_;
	print $apples, "\n";
	print $apples->[1], "\n";
	print @$oranges[1], "\n";
}
