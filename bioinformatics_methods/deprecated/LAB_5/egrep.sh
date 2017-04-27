#!/bin/sh
#Find CAR repeats
#A CAR repeat is CA followed by a puRine

egrep --color "(CA[AG]){6,}" amplicons.fasta
