#!/usr/bin/env python3

"""
Created on Feb 22, 2017

@author: valentine.c
"""

"""
Write a program that will print the complement of this sequence.
"""

sequence = 'ACTGATCGATTACGTATAGTATTTGCTATCATACATATATATCGATGCGTTCAT'.upper()

print(sequence.translate(''.maketrans('ACGT', 'TGCA')))
