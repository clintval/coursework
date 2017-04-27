#!/bin/sh

sed "s/100.00/Match/" blast_output.txt \
	| cut -f  2-4 | tail -n 20
