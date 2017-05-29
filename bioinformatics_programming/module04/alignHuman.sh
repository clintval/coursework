#!/usr/bin/sh
# Clint Valentine
# 10/24/2016

nice -n 19 bowtie2 \
    -x /home/valentine.c/BIOL6309/module04/human_x \
    -1 /scratch/SampleDataFiles/SRR765993_1.filt.fastq \
    -2 /scratch/SampleDataFiles/SRR765993_2.filt.fastq \
    -S human_x.sam \
    --no-unal \
    --threads 4 \
    1>human_x.log \
    2>human_x.err&
