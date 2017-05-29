#!/usr/bin/env python3
# Clint Valentine
# 3/2/2016

import re

blast_output = '/scratch/RNASeq/blastp.outfmt6'
parsed_blast = './parsed_blast.txt'

# Open BLAST output (reading) and an outfile (writing) for parsed data.
with open(blast_output) as infile, open(parsed_blast, 'w') as outfile:
    for line in infile:
        # Split on occurences of either a tab or pipe from the stripped line.
        line = re.split(r'[\t\|]', line.strip())

        # Unpack the line and save the required fields.
        transcript_id, isoform, _, _, _, swiss_id, _, identity, *_ = line

        # Write the fields tab-delimited to the end of outfile.
        line = '\t'.join([transcript_id, isoform, swiss_id, identity]) + '\n'
        outfile.write(line)
