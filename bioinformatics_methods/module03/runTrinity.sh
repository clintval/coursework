#!/usr/bin/sh
# Clint Valentine
# 10/13/2016

CPU=4
max_memory='20G'

seqType='fq'
SS_lib_type='RF'

left='trimmed.left.fq'
right='trimmed.right.fq'

nice -n 19 Trinity \
    --seqType $seqType \
    --SS_lib_type $SS_lib_type \
    --CPU $CPU \
    --max_memory $max_memory \
    --verbose \
    --left $left \
    --right $right


###############################################################################
#
#     ______  ____   ____  ____   ____  ______  __ __
#    |      ||    \ |    ||    \ |    ||      ||  |  |
#    |      ||  D  ) |  | |  _  | |  | |      ||  |  |
#    |_|  |_||    /  |  | |  |  | |  | |_|  |_||  ~  |
#      |  |  |    \  |  | |  |  | |  |   |  |  |___, |
#      |  |  |  .  \ |  | |  |  | |  |   |  |  |     |
#      |__|  |__|\_||____||__|__||____|  |__|  |____/
#
###############################################################################
#
# Required:
#
#  --seqType <string>      :type of reads: ( fa, or fq )
#
#  --max_memory <string>      :suggested max memory to use by Trinity where limiting can be enabled. (jellyfish, sorting, etc)
#                            provied in Gb of RAM, ie.  '--max_memory 10G'
#
#  If paired reads:
#      --left  <string>    :left reads, one or more file names (separated by commas, no spaces)
#      --right <string>    :right reads, one or more file names (separated by commas, no spaces)
#
#  Or, if unpaired reads:
#      --single <string>   :single reads, one or more file names, comma-delimited (note, if single file contains pairs, can use flag: --run_as_paired )
#
####################################
##  Misc:  #########################
#
#  --SS_lib_type <string>          :Strand-specific RNA-Seq read orientation.
#                                   if paired: RF or FR,
#                                   if single: F or R.   (dUTP method = RF)
#                                   See web documentation.
#
#  --CPU <int>                     :number of CPUs to use, default: 2
#  --min_contig_length <int>       :minimum assembled contig length to report
#                                   (def=200)
#
#  --long_reads <string>           :fasta file containing error-corrected or circular consensus (CCS) pac bio reads
#                                   (** note: experimental parameter **, this functionality continues to be under development)
#
#  --genome_guided_bam <string>    :genome guided mode, provide path to coordinate-sorted bam file.
#                                   (see genome-guided param section under --show_full_usage_info)
#
#  --jaccard_clip                  :option, set if you have paired reads and
#                                   you expect high gene density with UTR
#                                   overlap (use FASTQ input file format
#                                   for reads).
#                                   (note: jaccard_clip is an expensive
#                                   operation, so avoid using it unless
#                                   necessary due to finding excessive fusion
#                                   transcripts w/o it.)
#
#  --trimmomatic                   :run Trimmomatic to quality trim reads
#                                        see '--quality_trimming_params' under full usage info for tailored settings.
#
#
#  --normalize_reads               :run in silico normalization of reads. Defaults to max. read coverage of 50.
#                                       see '--normalize_max_read_cov' under full usage info for tailored settings.
#
#  --no_distributed_trinity_exec   :do not run Trinity phase 2 (assembly of partitioned reads), and stop after generating command list.
#
#
#  --output <string>               :name of directory for output (will be
#                                   created if it doesn't already exist)
#                                   default( your current working directory: "/home/valentine.c/BIOL6309/module03/trinity_out_dir"
#                                    note: must include 'trinity' in the name as a safety precaution! )
#
#  --full_cleanup                  :only retain the Trinity fasta file, rename as ${output_dir}.Trinity.fasta
#
#  --cite                          :show the Trinity literature citation
#
#  --verbose                       :provide additional job status info during the run.
#
#  --version                       :reports Trinity version (v2.2.0) and exits.
#
#  --show_full_usage_info          :show the many many more options available for running Trinity (expert usage).
#
#
###############################################################################
#
#  *Note, a typical Trinity command might be:
#
#        Trinity --seqType fq --max_memory 50G --left reads_1.fq  --right reads_2.fq --CPU 6
#
#
#    and for Genome-guided Trinity:
#
#        Trinity --genome_guided_bam rnaseq_alignments.csorted.bam --max_memory 50G
#                --genome_guided_max_intron 10000 --CPU 6
#
#     see: /usr/local/programs/trinityrnaseq-2.2.0/sample_data/test_Trinity_Assembly/
#          for sample data and 'runMe.sh' for example Trinity execution
#
#     For more details, visit: http://trinityrnaseq.github.io
#
###############################################################################



