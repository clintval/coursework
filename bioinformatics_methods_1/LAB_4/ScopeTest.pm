#use strict;
use warnings;

package ScopeTestPkg;

sub whatCanISee {
	print $visibleInPackage, "\n";
}
1;
