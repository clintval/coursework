#!/usr/bin/perl
use warnings;
use strict;
use BLAST2;

# 10 sample lines * 19 tests.
use Test::More tests => 190;

while (<DATA>) {
	chomp;

	my $blastObj = BLAST->new({ blastLine => $_ });

	# Ensure all attributes are defined after reading a blast line.
	ok( $blastObj->has_transcriptId() );
	ok( $blastObj->has_isoform() );
	ok( $blastObj->has_giType() );
	ok( $blastObj->has_gi() );
	ok( $blastObj->has_swissProtType() );
	ok( $blastObj->has_swissProtBase() );
	ok( $blastObj->has_swissProtVersion() );
	ok( $blastObj->has_proteinId() );
	ok( $blastObj->has_pident() );
	ok( $blastObj->has_length() );
	ok( $blastObj->has_mismatch() );
	ok( $blastObj->has_gapopen() );
	ok( $blastObj->has_qstart() );
	ok( $blastObj->has_qend() );
	ok( $blastObj->has_sstart() );
	ok( $blastObj->has_send() );
	ok( $blastObj->has_evalue() );
	ok( $blastObj->has_bitscore() );

	# Make sure whitespace was removed from bitscore.
	ok( index($blastObj->get_bitscore(), '') != -1 )
}

done_testing();

# This data was gathered using the command `head /scratch/RNASeq/blastp.outfmt6 -n 10`
__END__
c0_g1_i1|m.1	gi|74665200|sp|Q9HGP0.1|PVG4_SCHPO	100.00	372	0	0	1	372	1	372	0.0	  754
c1000_g1_i1|m.799	gi|48474761|sp|O94288.1|NOC3_SCHPO	100.00	747	0	0	5	751	1	747	0.0	 1506
c1001_g1_i1|m.800	gi|259016383|sp|O42919.3|RT26A_SCHPO	100.00	268	0	0	1	268	1	268	0.0	  557
c1002_g1_i1|m.801	gi|1723464|sp|Q10302.1|YD49_SCHPO	100.00	646	0	0	1	646	1	646	0.0	 1310
c1003_g1_i1|m.803	gi|74631197|sp|Q6BDR8.1|NSE4_SCHPO	100.00	246	0	0	1	246	1	246	1e-179	  502
c1004_g1_i1|m.804	gi|74676184|sp|O94325.1|PEX5_SCHPO	100.00	598	0	0	1	598	1	598	0.0	 1227
c1005_g1_i1|m.805	gi|9910811|sp|O42832.2|SPB1_SCHPO	100.00	802	0	0	1	802	1	802	0.0	 1644
c1006_g1_i1|m.806	gi|74627042|sp|O94631.1|MRM1_SCHPO	100.00	255	0	0	1	255	47	301	0.0	  525
c1007_g1_i1|m.807	gi|20137702|sp|O74370.1|ISY1_SCHPO	100.00	201	0	0	1	201	1	201	4e-146	  412
c1008_g1_i1|m.808	gi|3023676|sp|P56287.1|EI2BE_SCHPO	100.00	678	0	0	6	683	1	678	0.0	 1408
