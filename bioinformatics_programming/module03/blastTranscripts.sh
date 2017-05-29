#!/usr/bin/sh
# Clint Valentine
# 10/13/2016

# OLD COMMAND
# blastx \
#     -query Trinity.fasta.transdecoder.pep \
#     -db swissprot \
#     -num_threads 8 \
#     -max_target_seqs 1 \
#     -outfmt 6 \
#     1> blastp.outfmt6 \
#     2> blast.err &

blastx \
    -query trinity_out_dir/Trinity.fasta \
    -db swissprot \
    -num_threads 8 \
    -max_target_seqs 1 \
    -outfmt 6 \
    1>blastx.outfmt6 \
    2>blastx.err &
