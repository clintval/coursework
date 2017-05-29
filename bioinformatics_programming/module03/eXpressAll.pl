#!/usr/bin/perl
use warnings;
use strict;

# Clint Valentine
# 10/13/2016

foreach my $condition ('ds', 'hs', 'log', 'plat') {

    # I find join with sep=' ' to be easier to work with because spaces
    # are necessary between CLI parameters. Strictly concatenating does
    # not solve the need for spaces easily.
    my $exec = join ' ',
        '/usr/local/programs/trinityrnaseq-2.2.0/util/align_and_estimate_abundance.pl',
        '--seqType', 'fq',
        '--left', $condition . '.p.left.fq',
        '--right', $condition . '.p.right.fq',
        '--transcripts', 'trinity_out_dir/Trinity.fasta',
        '--output_dir', 'Sp_' . $condition,
        '--est_method', 'eXpress',
        '--aln_method', 'bowtie',
        '--trinity_mode',
        '--prep_reference';

    unless ( open( SYSCALL, $exec . ' | ') ) {
        die "can't open the SYSCALL", $!;
    }

    while (<SYSCALL>) {
        print;
    }
    close SYSCALL
}
