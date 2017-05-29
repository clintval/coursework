package BLAST;
use Moose;
use MooseX::FollowPBP;

sub BUILD {
	my ( $self, $args ) = @_;

	# Split the line on tabs and assign results to named variables.
	my (
		$qseqid, $sseqid, $pident, $length, $mismatch, $gapopen, $qstart, $qend,
		$sstart, $send, $evalue, $bitscore ) =
		split /\t/, $args->{blastLine};

	my ( $transcriptId, $isoform ) =
		split /\|/, $qseqid;
	my ( $giType, $gi, $swissProtType, $swissProtId, $proteinId ) =
		split /\|/, $sseqid;

	my ( $swissProtBase, $swissProtVersion ) =
		split /\./, $swissProtId;

	$self->{bitscore}         = $bitscore;
	$self->{evalue}           = $evalue;
	$self->{gi}               = $gi;
	$self->{giType}           = $giType;
	$self->{gapopen}          = $gapopen;
	$self->{isoform}          = $isoform;
	$self->{length}           = $length;
	$self->{mismatch}         = $mismatch;
	$self->{pident}           = $pident;
	$self->{proteinId}        = $proteinId;
	$self->{qend}             = $qend;
	$self->{qseqid}           = $qseqid;
	$self->{qstart}           = $qstart;
	$self->{send}             = $send;
	$self->{sseqid}           = $sseqid;
	$self->{sstart}           = $sstart;
	$self->{swissProtBase}    = $swissProtBase;
	$self->{swissProtVersion} = $swissProtVersion;
	$self->{swissProtId}      = $swissProtId;
	$self->{swissProtType}    = $swissProtType;
	$self->{transcriptId}     = $transcriptId;
}

sub printAll {
	my ( $self ) = @_;

	# Create an array of attributes, if they are not defined substitute with ''.
	my @line = (
		$self->get_transcriptId() // '',
		$self->get_isoform() // '',
		$self->get_giType() // '',
		$self->get_gi() // '',
		$self->get_swissProtType() // '',
		$self->get_swissProtBase() // '',
		$self->get_swissProtVersion() // '',
		$self->get_proteinId() // '',
		$self->get_pident() // '',
		$self->get_length() // '',
		$self->get_mismatch() // '',
		$self->get_gapopen() // '',
		$self->get_qstart() // '',
		$self->get_qend() // '',
		$self->get_sstart() // '',
		$self->get_send() // '',
		$self->get_evalue() // '',
		$self->get_bitscore() // '');

	# DOT NOT REMOVE EMPTY STRINGS. This preserves columnar formatting
	# Remove all empty string fields in the line.
	#@line = grep /\S/, @line;

	# Join all elements in the line and append newline if this list has fields.
	print join( "\t", @line ) . "\n" if grep { defined($_) } @line;
}

# Attribute definitions
has 'qseqid' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_qseqid',
	predicate => 'has_qseqid',
	);
has 'sseqid' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_sseqid',
	predicate => 'has_sseqid',
	);
has 'pident' => (
	is  => 'ro',
	isa => 'Num',
	clearer => 'clear_pident',
	predicate => 'has_pident',
	);
has 'length' => (
	is  => 'ro',
	isa => 'Int',
	clearer => 'clear_length',
	predicate => 'has_length',
	);
has 'mismatch' => (
	is  => 'ro',
	isa => 'Int',
	clearer => 'clear_mismatch',
	predicate => 'has_mismatch',
	);
has 'gapopen' => (
	is  => 'ro',
	isa => 'Int',
	clearer => 'clear_gapopen',
	predicate => 'has_gapopen',
	);
has 'qstart' => (
	is  => 'ro',
	isa => 'Int',
	clearer => 'clear_qstart',
	predicate => 'has_qstart',
	);
has 'qend' => (
	is  => 'ro',
	isa => 'Int',
	clearer => 'clear_qend',
	predicate => 'has_qend',
	);
has 'sstart' => (
	is  => 'ro',
	isa => 'Int',
	clearer => 'clear_sstart',
	predicate => 'has_sstart',
	);
has 'send' => (
	is  => 'ro',
	isa => 'Int',
	clearer => 'clear_send',
	predicate => 'has_send',
	);
has 'evalue' => (
	is  => 'ro',
	isa => 'Num',
	clearer => 'clear_evalue',
	predicate => 'has_evalue',
	);
has 'bitscore' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_bitscore',
	predicate => 'has_bitscore',
	);
has 'gi' => (
	is  => 'ro',
	isa => 'Int',
	clearer => 'clear_gi',
	predicate => 'has_gi',
	);
has 'giType' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_giType',
	predicate => 'has_giType',
	);
has 'isoform' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_isoform',
	predicate => 'has_isoform',
	);
has 'proteinId' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_proteinId',
	predicate => 'has_proteinId',
	);
has 'proteinId' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_proteinId',
	predicate => 'has_proteinId',
	);
has 'swissProtId' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_swissProtId',
	predicate => 'has_swissProtId',
	);
has 'swissProtType' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_swissProtType',
	predicate => 'has_swissProtType',
	);
has 'transcriptId' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_transcriptId',
	predicate => 'has_transcriptId',
	);
has 'swissProtBase' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_swissProtBase',
	predicate => 'has_swissProtBase',
	);
has 'swissProtVersion' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_swissProtVersion',
	predicate => 'has_swissProtVersion',
	);
1;
