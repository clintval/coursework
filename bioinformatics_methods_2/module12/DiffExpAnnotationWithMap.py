#!/usr/bin/env python3
import re

__author__ = 'clint valentine'

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


def parse_matrix_line(line):
    """Parses a line of matrix output and substitutes transcript_id with
    swiss_id if it exists in the known global dictionary of transcript to
    protein IDs.protein

    PARAMETERS
    ----------
    line : str
        A line of valid differential expression matrix output (no header)

    RETURNS
    -------
    modified_line : tuple
        A field seperated tuple of input data with the transcript ID replaced
        with the swissprot ID only if it exists.

    """
    # Strip, split, and unpack line.
    transcript_id, *stats = line.strip().split('\t')

    # Get the corresponding swiss_id. If it does not exist then set
    # the line_id to the transcript_id as default.
    line_id = TRANSCRIPT_TO_PROTEIN.get(transcript_id, transcript_id)

    # Join the new line ID to the list of stats and convert all to tuple.
    modified_line = tuple([line_id] + stats)
    return modified_line


if __name__ == '__main__':
    blast_output = '/scratch/RNASeq/blastp.outfmt6'
    matrix_output = '/scratch/RNASeq/diffExpr.P1e-3_C2.matrix'

    with open(blast_output) as handle:
        for line in handle:
            # Parse BLAST line and save transcript_id : swiss_id in a dict.
            transcript_id, swiss_id = parse_blast_line(line=line)
            TRANSCRIPT_TO_PROTEIN[transcript_id] = swiss_id

    with open(matrix_output) as handle:
        # Consume the header by printing it.
        print('\t' + next(handle).strip())

        # Parse each line in matrix file, looking up transcript_id if exists.
        matrix_lines = map(parse_matrix_line, handle.readlines())

    # Join each tuple with tabs then join all joined strings with newlines.
    print('\n'.join(map(lambda line: '\t'.join(line), matrix_lines)))
