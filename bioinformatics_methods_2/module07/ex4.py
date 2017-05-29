#!/usr/bin/env python3

import re

"""
Created on Feb 22, 2017

@author: valentine.c
"""

"""
Write a program which will calculate the size of the two fragments that will be
produced when the DNA sequence is digested with EcoRI.
"""

sequence = 'ACTGATCGATTACGTATAGTAGAATTCTATCATACATATATATCGATGCGTTCAT'.upper()

for match in re.finditer('GAATTC', sequence):
    cut_point = match.start() + 1
    left, right = len(sequence[:cut_point]), len(sequence[cut_point:])
    print("Fragments of length {} and {}".format(left, right))
