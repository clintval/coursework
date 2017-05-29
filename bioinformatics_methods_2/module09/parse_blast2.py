#!/usr/bin/env python3
import re

__author__ = "clint valentine"

TRANSCRIPT_TO_PROTEIN = {}


def parse_blast_line(line):
    """Parses a line of BLAST output and returns transcript_id and swiss_id.

    PARAMETERS
    ----------
    line : str
        A line of valid BLAST output.

    RETURNS
    -------
    transcript_id : str
        The parsed transcript ID.
    swiss_id : str
        The parsed protein ID.

    """
    # Split on occurences of either a tab or pipe from the stripped line.
    line = re.split(r'[\t\|]', line.strip())

    assert len(line) == 17, 'Line does not have expected number of fields'

    # Unpack the line and save the required fields.
    transcript_id, _, _, _, _, swiss_id, *_ = line

    return transcript_id, swiss_id


if __name__ == '__main__':
    blast_output = '/scratch/RNASeq/blastp.outfmt6'
    matrix_output = '/scratch/RNASeq/diffExpr.P1e-3_C2.matrix'

    # Open BLAST output (reading).
    with open(blast_output) as handle:
        for line in handle:
            # Parse BLAST line and save transcript_id : swiss_id in a dict.
            transcript_id, swiss_id = parse_blast_line(line=line)
            TRANSCRIPT_TO_PROTEIN[transcript_id] = swiss_id

    # Open the matrix file and print out contents with the transcript_id
    # converted to swiss_id if it exists.
    with open(matrix_output) as handle:
        for line in handle:
            # Strip, split, and unpack line.
            transcript_id, *stats = line.strip().split('\t')

            # Get the corresponding swiss_id. If it does not exist then set
            # swiss_id = transcript_id as default.
            swiss_id = TRANSCRIPT_TO_PROTEIN.get(transcript_id, transcript_id)

            # Join all data and print to STDOUT.
            print('\t'.join([swiss_id] + stats))
