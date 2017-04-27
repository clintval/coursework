#!/usr/bin/sh
# Clint Valentine
# 10/13/2016

java -jar /usr/local/programs/Trimmomatic-0.36/trimmomatic-0.36.jar \
  PE \
  -threads 4 \
  -phred33 \
  -trimlog ds.log \
  /scratch/TrinityNatureProtocolTutorial/1M_READS_sample/Sp.ds.1M.left.fq \
  /scratch/TrinityNatureProtocolTutorial/1M_READS_sample/Sp.ds.1M.right.fq \
  ds.p.left.fq \
  ds.u.left.fq \
  ds.p.right.fq \
  ds.u.right.fq \
  ILLUMINACLIP:/usr/local/programs/Trimmomatic-0.36/adapters/TruSeq3-PE.fa:2:30:10 \
  LEADING:3
