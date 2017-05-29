package BLAST;
use Moose;
# Clint Valentine
# January 30 2017

sub parseBlastLine {
	my ( $self, $blastRecord ) = @_;

	# Split the line on tabs and assign results to named variables.
	my (
		$qseqid, $sseqid, $pident, $length, $mismatch, $gapopen, $qstart, $qend,
		$sstart, $send, $evalue, $bitscore ) = split /\t/, $blastRecord;

	$self->qseqid( $qseqid );
	$self->sseqid( $sseqid );
	$self->pident( $pident );
	$self->length( $length );
	$self->mismatch( $mismatch );
	$self->gapopen( $gapopen );
	$self->qstart( $qstart );
	$self->qend( $qend );
	$self->sstart( $sstart );
	$self->send( $send );
	$self->evalue( $evalue );
	$self->bitscore( $bitscore );
}

sub printAll {
	my ( $self ) = @_;

	# Create an array of attributes, if they are not defined than substitute an
	# empty string.
	my @line = (
		$self->transcriptId() // '',
		$self->isoform() // '',
		$self->giType() // '',
		$self->gi() // '',
		$self->swissProtType() // '',
		$self->swissProtBase() // '',
		$self->swissProtVersion() // '',
		$self->proteinId() // '',
		$self->pident() // '',
		$self->length() // '',
		$self->mismatch() // '',
		$self->gapopen() // '',
		$self->qstart() // '',
		$self->qend() // '',
		$self->sstart() // '',
		$self->send() // '',
		$self->evalue() // '',
		$self->bitscore() // '');

	#Remove all empty string fields in the line.
	@line = grep /\S/, @line;

	# Join all elements in the line and append newline if this list has fields.
	print join( "\t", @line ) . "\n" if grep { defined($_) } @line;
}

# Default fields. Some, like qseqid and sseqid trigger small routines which
# populate the namespace with more specific attributes.
has 'qseqid' => (
	is  => 'rw',
	isa => 'Str',
	trigger =>
		sub {
			my ( $self, $param ) = @_;
			( $self->{transcriptId}, $self->{isoform} ) = split /\|/, $param;
		}
);
has 'sseqid' => (
	is  => 'rw',
	isa => 'Str',
	trigger =>
		sub {
			my ( $self, $param ) = @_;

			my ( $giType,$gi,
					 $swissProtType,
					 $swissProtId,
					 $proteinId ) = split( /\|/, $param );

			my ( $swissProtBase, $swissProtVersion ) = split /\./, $swissProtId;

			$self->{giType} = $giType;
			$self->{gi} = $gi;
			$self->{swissProtBase} = $swissProtBase;
			$self->{swissProtVersion} = $swissProtVersion;
			$self->{swissProtType} = $swissProtType;
			$self->{swissProtId} = $swissProtId;
			$self->{proteinId} = $proteinId;
		}
);
has 'pident' => (
	is  => 'rw',
	isa => 'Num',
);
has 'length' => (
	is  => 'rw',
	isa => 'Int',
);
has 'mismatch' => (
	is  => 'rw',
	isa => 'Int',
);
has 'gapopen' => (
	is  => 'rw',
	isa => 'Int',
);
has 'qstart' => (
	is  => 'rw',
	isa => 'Int',
);
has 'qend' => (
	is  => 'rw',
	isa => 'Int',
);
has 'sstart' => (
	is  => 'rw',
	isa => 'Int',
);
has 'send' => (
	is  => 'rw',
	isa => 'Int',
);
has 'evalue' => (
	is  => 'rw',
	isa => 'Num',
);
has 'bitscore' => (
	is  => 'rw',
	isa => 'Str',
	trigger => sub {
		my ( $self, $param ) = @_;
		# Remove whitespace padding from bitscore.
		$self->{bitscore} =~ s/^\s+|\s+$//g;
	}

);

# The following attributes are imputed at full object initialization.
has 'gi' => (
	is  => 'rw',
	isa => 'Int',
);
has 'giType' => (
	is  => 'rw',
	isa => 'Str',
);
has 'isoform' => (
	is  => 'rw',
	isa => 'Str',
);
has 'proteinId' => (
	is  => 'rw',
	isa => 'Str',
);

has 'proteinId' => (
	is  => 'rw',
	isa => 'Str',
);
has 'swissProtId' => (
	is  => 'rw',
	isa => 'Str',
);
has 'swissProtType' => (
	is  => 'rw',
	isa => 'Str',
);
has 'transcriptId' => (
	is  => 'rw',
	isa => 'Str',
);
has 'swissProtBase' => (
	is  => 'rw',
	isa => 'Str',
);
has 'swissProtVersion' => (
	is  => 'rw',
	isa => 'Str',
);
1;
