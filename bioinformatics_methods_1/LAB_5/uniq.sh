#!/bin/sh

sort blast_output.txt -k7 -k8 -n | cut -f 7-8 | uniq -c
