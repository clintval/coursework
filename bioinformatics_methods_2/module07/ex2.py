#!/usr/bin/env python3

"""
Created on Feb 22, 2017

@author: valentine.c
"""

"""
Write a program that will print out the AT content of this DNA sequence.
"""

sequence = 'ACTGATCGATTACGTATAGTATTTGCTATCATACATATATATCGATGCGTTCAT'.upper()

print((sequence.count('A') + sequence.count('T')) / len(sequence))
