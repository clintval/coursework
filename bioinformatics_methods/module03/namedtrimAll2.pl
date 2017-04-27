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
        'java -jar /usr/local/programs/Trimmomatic-0.36/trimmomatic-0.36.jar',
        'PE',
        '-threads 4',
        '-phred33',
        '-trimlog', $condition . '.log',
        '/scratch/TrinityNatureProtocolTutorial/1M_READS_sample/Sp.' . $condition . '.1M.left.fq',
        '/scratch/TrinityNatureProtocolTutorial/1M_READS_sample/Sp.' . $condition . '.1M.right.fq',
        $condition . '.p.left.fq',
        $condition . '.u.left.fq',
        $condition . '.p.right.fq',
        $condition . '.u.right.fq',
        'ILLUMINACLIP:/usr/local/programs/Trimmomatic-0.36/adapters/TruSeq3-PE.fa:2:30:10',
        'LEADING:3';

    unless ( open( SYSCALL, $exec . ' | ') ) {
        die "can't open the SYSCALL", $!;
    }

    while (<SYSCALL>) {
        print;
    }
    close SYSCALL
}
