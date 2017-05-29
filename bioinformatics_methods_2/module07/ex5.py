#!/usr/bin/env python3

"""
Created on Feb 22, 2017

@author: valentine.c
"""

"""
Write a program that will print just the coding regions of the DNA sequence.
"""

sequence = ('ATCGATCGATCGATCGACTGACTAGTCATAGCTATGCATGTAGCTACTCGATCGATCGA'
            'TCGATCGATCGATCGATCGATCGATCATGCTATCATCGATCGATATCGATGCATCGACT'
            'ACTAT').upper()

exon = ''.join([sequence[:63], sequence[90:]])
print("Exon sequence: {}".format(exon))

"""
Using the data from part one, write a program that will calculate what
percentage of the DNA sequence is coding.
"""

print("Percent of DNA that is coding: {}".format(len(exon) / len(sequence)))

"""
Using the data from part one, write a program that will print out the original
genomic DNA sequence with coding bases in uppercase and non-coding bases in
lowercase.
"""

print("New sequence: {}".format(''.join(
    [sequence[:62].upper(),
     sequence[62:90].lower(),
     sequence[90:].upper()])))
