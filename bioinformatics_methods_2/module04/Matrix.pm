package Matrix;
use Moose;
use MooseX::FollowPBP;

sub BUILD {
	my ( $self, $args ) = @_;

	my (
		$transcript_id, $Sp_ds, $Sp_hs, $Sp_log, $Sp_plat ) =
		split /\t/, $args->{expressionLine};

	$self->{transcript_id} = $transcript_id;
	$self->{Sp_ds} = $Sp_ds;
	$self->{Sp_hs} = $Sp_hs;
	$self->{Sp_log} = $Sp_log;
	$self->{Sp_plat} = $Sp_plat;
}

has 'transcript_id' => (
	is => 'ro',
	isa => 'Str',
	clearer => 'clear_transcript_id',
	predicate => 'has_transcript_id',
	);
has 'Sp_ds' => (
	is => 'ro',
	isa => 'Num',
	clearer => 'clear_Sp_ds',
	predicate => 'has_Sp_ds',
	);
has 'Sp_hs' => (
	is => 'ro',
	isa => 'Num',
	clearer => 'clear_Sp_hs',
	predicate => 'has_Sp_hs',
	);
has 'Sp_log' => (
	is => 'ro',
	isa => 'Num',
	clearer => 'clear_Sp_log',
	predicate => 'has_Sp_log',
	);
has 'Sp_plat' => (
	is => 'ro',
	isa => 'Num',
	clearer => 'clear_Sp_plat',
	predicate => 'has_Sp_plat',
	);
1;
