package Report;
use Data::Dumper;
use Moose;
use MooseX::FollowPBP;

use GO2;
use Matrix;

sub printAll {
	my ($self) = @_;
	my $termCount = 0;

	open( REPORT, '>>', 'report.txt' ) or die $!;

	foreach my $goTerm ( @{ $self->{goTerms} } ) {
		$termCount++;
		if ( $termCount == 1 ) {
			print REPORT join( "\t",
				$self->{matrix}->get_transcript_id,
				$self->{matrix}->get_Sp_ds,
				$self->{matrix}->get_Sp_hs,
				$self->{matrix}->get_Sp_log,
				$self->{matrix}->get_Sp_plat,
				$self->{proteinId},
				$goTerm->get_id(),
				$goTerm->get_name(),
				$self->{proteinDesc} ) . "\n";
		}
		else {
			print REPORT join( "\t",
				" ", " ", " ", " ", " ", " ", " ",
				$goTerm->get_id(),
				$goTerm->get_name() ) . "\n";
		}
	}
}

# Accepts a line of BLAST output
sub BUILD {
	my ( $self, $args ) = @_;

	$self->{goTerms}     = $args->{goTerms};
	$self->{matrix}      = $args->{matrix};
	$self->{proteinId}   = $args->{proteinId};
	$self->{proteinDesc} = $args->{proteinDesc};
}

has 'matrix' => (
	is        => 'ro',
	isa       => 'Matrix',
	clearer   => 'clear_matrix',
	predicate => 'has_matrix',
	);
has 'proteinId' => (
	is        => 'ro',
	isa       => 'Str',
	clearer   => 'clear_proteinId',
	predicate => 'has_proteinId',
	);
has 'proteinDesc' => (
	is        => 'ro',
	isa       => 'Str',
	clearer   => 'clear_proteinDesc',
	predicate => 'has_proteinDesc',
	);
has 'goTerms' => (
	is        => 'ro',
	isa       => 'ArrayRef',
	clearer   => 'clear_goTerms',
	predicate => 'has_goTerms',
	);
1;
