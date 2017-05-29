#!/usr/bin/perl
#use warnings;
#use strict;

package ScopeTestPkg;
use ScopeTest;
$visibleInPackage = "Visible in package";
#print $nestedBlock, "\n"; ­ not visible here

my $visibleInScopePl = "Visible in this file";
whatCanISee();
print $visibleInScopePl, "\n";
{
	my $varInBlock = "Visible in outer block";
	print $varInBlock, "\n";
	{
		my $nestedBlock = "Visible in inner block";
		print $nestedBlock, "\n";
	}
}
