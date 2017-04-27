#!/usr/bin/sh
# Clint Valentine
# 10/13/2016

/usr/local/programs/trinityrnaseq-2.2.0/Analysis/DifferentialExpression/run_DE_analysis.pl \
    --matrix Trinity_Isoforms.counts.matrix \
    --method edgeR \
    --dispersion .35
