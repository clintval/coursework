#!/usr/bin/perl
use warnings;
use strict;
use Matrix;

# 10 sample lines * 100 tests.
use Test::More tests => 100;

while (<DATA>) {
	chomp;

	my $matrix = Matrix->new({ expressionLine => $_ });

	# Ensure all attributes are defined after reading a blast line.
	ok( $matrix->has_transcript_id() );
	ok( $matrix->has_Sp_ds() );
	ok( $matrix->has_Sp_hs() );
	ok( $matrix->has_Sp_log() );
	ok( $matrix->has_Sp_plat() );

	ok( defined $matrix->get_transcript_id() );
	ok( defined $matrix->get_Sp_ds() );
	ok( defined $matrix->get_Sp_hs() );
	ok( defined $matrix->get_Sp_log() );
	ok( defined $matrix->get_Sp_plat() );
}

done_testing();

# This data was gathered using the command `head /scratch/RNASeq/blastp.outfmt6 -n 11 | tail -10`
__END__
c3833_g1_i2	4.00	0.07	16.84	26.37
c4832_g1_i1	24.55	116.87	220.53	28.82
c5161_g1_i1	107.49	89.39	26.95	698.97
c4399_g1_i2	27.91	72.57	5.56	36.58
c5916_g1_i1	82.57	19.03	48.55	258.22
c73_g1_i1	109.25	0.00	1.69	249.04
c2672_g1_i1	26.55	88.25	296.03	20.74
c4859_g1_i1	863.50	8798.74	2081.02	53.46
c6085_g1_i1	86.52	34.05	6.62	77.17
c5949_g1_i1	544.55	88.38	9.00	770.03
