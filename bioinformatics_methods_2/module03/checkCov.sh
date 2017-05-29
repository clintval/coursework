#!/usr/bin/sh
# Clint Valentine
# 10/13/2016

/usr/local/programs/trinityrnaseq-2.2.0/util/analyze_blastPlus_topHit_coverage.pl \
    Trinity_vs_S_pombe_refTrans.blastn \
    trinity_out_dir/Trinity.fasta \
    /scratch/TrinityNatureProtocolTutorial/S_pombe_refTrans.fasta
