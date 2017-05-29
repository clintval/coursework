#!/usr/bin/sh
# Clint Valentine
# 10/24/2016

nice -n 19 \
    bowtie2 -x /usr/local/programs/bowtie2-2.2.4/example/index/lambda_virus \
    -1 /usr/local/programs/bowtie2-2.2.4/example/reads/reads_1.fq \
    -2 /usr/local/programs/bowtie2-2.2.4/example/reads/reads_2.fq \
    -S lambda_virus.sam \
    1>bowtie2.log \
    2>bowtie2.err&
