#!/usr/bin/perl
use warnings;
use strict;
use GO2;

use Test::More tests => 76;

#Initialize $_ to prevent warnings in redefinition of $/ as RegEx
$_ = '';
local $/ = /\[Term\]|\[Typedef\]/;

# Read the test data line-by-line. DATA is a special filehandle for testting.
# It reads everything below __END__ as an input file. This special
# filehandle allows test scripts to be created with their own builtin
# test data.
while (<DATA>) {
	chomp;

	my $go = GO->new({ longGoDesc => $_ });

	# Test predicates to see if all attributes were set.
	ok( $go->has_id() );
	ok( $go->has_def() );
	ok( $go->has_name() );
	ok( $go->has_namespace() );
	ok( $go->has_is_as() );
	ok( $go->has_alt_ids() );

	ok( defined $go->get_id() );
	ok( defined $go->get_def() );
	ok( defined $go->get_name() );
	ok( defined $go->get_namespace() );
	ok( defined $go->get_is_as() );
	ok( defined $go->get_alt_ids() );

	# Test is_as Array
	my $isaCount = 0;
	foreach my $isaRef ( keys $go->get_is_as() ) {
		ok( $go->get_is_as()->[$isaRef] );
		$isaCount++;
	}
	ok( $isaCount > 0 );

	# Test alt_ids Array
	my $altIdCount = 0;
	if ( defined $go->get_alt_ids() ) {
		foreach my $altIdRef ( keys $go->get_alt_ids() ) {
			ok( $go->get_alt_ids()->[$altIdRef] );
			$altIdCount++;
		}
	}
	ok( $altIdCount > 0 );
}

# Indicate that tests are done
done_testing();

# Everything below __END__ is treated as input for the DATA handle.
# I created this with the command:
# tail -n 100 /scratch/go-basic.obo >> GO.t
# Followed by some manual editing to remove incomplete records and add alt_ids
__END__
[Term]
id: GO:2001315
name: UDP-4-deoxy-4-formamido-beta-L-arabinopyranose biosynthetic process
namespace: biological_process
alt_id: GO:0019901
def: "The chemical reactions and pathways resulting in the formation of a UDP-4-deoxy-4-formamido-beta-L-arabinopyranose." [CHEBI:47027, GOC:yaf, UniPathway:UPA00032]
synonym: "UDP-4-deoxy-4-formamido-beta-L-arabinopyranose anabolism" EXACT [GOC:obol]
synonym: "UDP-4-deoxy-4-formamido-beta-L-arabinopyranose biosynthesis" EXACT [GOC:obol]
synonym: "UDP-4-deoxy-4-formamido-beta-L-arabinopyranose formation" EXACT [GOC:obol]
synonym: "UDP-4-deoxy-4-formamido-beta-L-arabinopyranose synthesis" EXACT [GOC:obol]
is_a: GO:0009226 ! nucleotide-sugar biosynthetic process
is_a: GO:0046349 ! amino sugar biosynthetic process
is_a: GO:2001313 ! UDP-4-deoxy-4-formamido-beta-L-arabinopyranose metabolic process

[Term]
id: GO:2001316
name: kojic acid metabolic process
namespace: biological_process
alt_id: GO:0019902
def: "The chemical reactions and pathways involving kojic acid." [CHEBI:43572, GOC:di]
synonym: "5-hydroxy-2-(hydroxymethyl)-4H-pyran-4-one metabolic process" EXACT [CHEBI:43572, GOC:obol]
synonym: "5-hydroxy-2-(hydroxymethyl)-4H-pyran-4-one metabolism" EXACT [CHEBI:43572, GOC:obol]
synonym: "C6H6O4 metabolic process" RELATED [CHEBI:43572, GOC:obol]
synonym: "C6H6O4 metabolism" RELATED [CHEBI:43572, GOC:obol]
synonym: "kojic acid metabolism" EXACT [GOC:obol]
is_a: GO:0034308 ! primary alcohol metabolic process
is_a: GO:0042180 ! cellular ketone metabolic process
is_a: GO:0046483 ! heterocycle metabolic process
is_a: GO:1901360 ! organic cyclic compound metabolic process

[Term]
id: GO:2001317
name: kojic acid biosynthetic process
namespace: biological_process
alt_id: GO:0019903
def: "The chemical reactions and pathways resulting in the formation of kojic acid." [CHEBI:43572, GOC:di]
synonym: "5-hydroxy-2-(hydroxymethyl)-4H-pyran-4-one anabolism" EXACT [CHEBI:43572, GOC:obol]
synonym: "5-hydroxy-2-(hydroxymethyl)-4H-pyran-4-one biosynthesis" EXACT [CHEBI:43572, GOC:obol]
synonym: "5-hydroxy-2-(hydroxymethyl)-4H-pyran-4-one biosynthetic process" EXACT [CHEBI:43572, GOC:obol]
synonym: "5-hydroxy-2-(hydroxymethyl)-4H-pyran-4-one formation" EXACT [CHEBI:43572, GOC:obol]
synonym: "5-hydroxy-2-(hydroxymethyl)-4H-pyran-4-one synthesis" EXACT [CHEBI:43572, GOC:obol]
synonym: "C6H6O4 anabolism" RELATED [CHEBI:43572, GOC:obol]
synonym: "C6H6O4 biosynthesis" RELATED [CHEBI:43572, GOC:obol]
synonym: "C6H6O4 biosynthetic process" RELATED [CHEBI:43572, GOC:obol]
synonym: "C6H6O4 formation" RELATED [CHEBI:43572, GOC:obol]
synonym: "C6H6O4 synthesis" RELATED [CHEBI:43572, GOC:obol]
synonym: "kojic acid anabolism" EXACT [GOC:obol]
synonym: "kojic acid biosynthesis" EXACT [GOC:obol]
synonym: "kojic acid formation" EXACT [GOC:obol]
synonym: "kojic acid synthesis" EXACT [GOC:obol]
is_a: GO:0018130 ! heterocycle biosynthetic process
is_a: GO:0034309 ! primary alcohol biosynthetic process
is_a: GO:0042181 ! ketone biosynthetic process
is_a: GO:1901362 ! organic cyclic compound biosynthetic process
is_a: GO:2001316 ! kojic acid metabolic process
synonym: "Roundabout signalling pathway involved in muscle cell chemotaxis toward tendon cell" EXACT [GOC:obol]
synonym: "Roundabout signalling pathway involved in muscle cell chemotaxis towards tendon cell" EXACT [GOC:obol]
is_a: GO:0035385 ! Roundabout signaling pathway
relationship: part_of GO:0036061 ! muscle cell chemotaxis toward tendon cell

[Term]
id: GO:2001284
name: regulation of BMP secretion
namespace: biological_process
alt_id: GO:0019904
def: "Any process that modulates the frequency, rate or extent of BMP secretion." [GOC:sart]
synonym: "regulation of BMP protein secretion" EXACT [GOC:obol]
synonym: "regulation of bone morphogenetic protein secretion" EXACT [GOC:obol]
is_a: GO:0010646 ! regulation of cell communication
is_a: GO:0023051 ! regulation of signaling
is_a: GO:0050708 ! regulation of protein secretion
relationship: regulates GO:0038055 ! BMP secretion
