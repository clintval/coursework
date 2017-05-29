#!/usr/bin/env python3
import re

__author__ = 'clint valentine'

BLAST_RECORDS = {}


class BLAST_record(object):
    def __init__(self, line):
        """Parses a line of BLAST output sets all fields as public attributes.

        PARAMETERS
        ----------
        line : str
            A line of valid BLAST output.

        """
        # Split on occurences of either a tab or pipe from the stripped line.
        line = re.split(r'[\t\|]', line.strip())

        assert len(line) == 17, 'Line does not have expected number of fields'

        # Unpack the line and save the required fields.
        (self.transcript_id, self.isoform, _, self.gi, _, self._full_swiss_id,
         self.protein, self.identity, self.length, self.mismatch, self.gapopen,
         self.query_start, self.query_end, self.target_start, self.target_end,
         self.evalue, self.bitscore) = line

        self.swiss_id, self.swiss_version = self._full_swiss_id.split('.')


class MATRIX_record(object):
    def __init__(self, line):
        """Parses a line of RNASeq matrix data and sets all fields as public
        attributes.

        PARAMETERS
        ----------
        line : str
            A line of valid .matrix output.

        """
        (self.transcript_id, self.Sp_ds, self.Sp_hs, self.Sp_log,
         self.Sp_plat) = line.strip().split('\t')

        # Grab the swiss_id, if exists, from the BLAST_RECORD dictionary and
        # set as a self.protein attribute. If the record cannot be found then
        # set the self.protein attribute to the BLAST record transcript_id.
        if self.transcript_id in BLAST_RECORDS:
            self.protein = BLAST_RECORDS[self.transcript_id].swiss_id
        else:
            self.protein = self.transcript_id

    def __repr__(self):
        iterable = (
            self.protein,
            self.Sp_ds,
            self.Sp_hs,
            self.Sp_log,
            self.Sp_plat
        )
        return tuple_to_tab_sep(iterable)


def identity_threshold(blast_record, threshold=95):
    return True if float(blast_record.identity) > threshold else False


def tuple_to_tab_sep(iterable):
    return '\t'.join(iterable)


if __name__ == '__main__':
    blast_output = '/scratch/RNASeq/blastp.outfmt6'
    matrix_output = '/scratch/RNASeq/diffExpr.P1e-3_C2.matrix'

    # Create a blast object for each BLAST output line.
    with open(blast_output) as handle:
        blast_records = map(BLAST_record, handle.readlines())

    # Filter all blast records for those with 95 percent identity or greater.
    # Store blast objects in global dictionary with transcript_id as key.
    BLAST_RECORDS = {record.transcript_id: record for record in
                     filter(identity_threshold, blast_records)}

    # Consume header and create matrix objects for each matrix output line.
    with open(matrix_output) as handle:
        header = next(handle)
        matrix_records = map(MATRIX_record, handle.readlines())

    # Print to stdout all matrix records preceeded by the header.
    print(header)
    for matrix_record in matrix_records:
        # Used magic __repr__ method for printing records.
        print(matrix_record)

