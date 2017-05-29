package GO;
use Moose;
use MooseX::FollowPBP;

# This subroutine parses a record from go-basic.obo
sub BUILD {
	my ( $self, $args ) = @_;
	my $longGoDesc = $args->{longGoDesc};

	if ( $longGoDesc =~ /\[Term\]/ ) {
		# Regex to get id, name, namespace , and def
		my $goDescParseRegex = qr/
			^id:\s+(?<id>.*?)\s+
			^name:\s+(?<name>.*?)\s+
			^namespace:\s+(?<namespace>.*?)\s+
			^def:\s+\"(?<def>.*?)\"
			/msx;

		# Regex to get all is_a Go Terms
		my $findIsa = qr/
			^is_a:\s+(?<is_a>.*?)\s+!
			/msx;

		# Regex to get all alt_id Go Terms
		my $findAltId = qr/
			^alt_id:\s+(?<alt_id>.*?)\s+
			/msx;

		if ( $longGoDesc =~ /$goDescParseRegex/ ) {

			$self->{id} = $+{id};
			$self->{name} = $+{name};
			$self->{namespace} = $+{namespace};
			$self->{def} = $+{def};

			my @altIdArray;
			while ( $longGoDesc =~ /$findAltId/g ) {
				push( @altIdArray, $+{alt_id} );
			}

			$self->{alt_ids} = \@altIdArray;

			my @is_as = ();
			while ( $longGoDesc =~ /$findIsa/g ) {
				push( @is_as, $+{is_a} );
			}
			$self->{is_as} = \@is_as;
		}

		else {
			print STDERR $longGoDesc, "\n";
		}
	}
}

sub printAll {
	# Get the $self parameter
	my ($self) = @_;

	# Print the id
	print $self->id(), "\t";
	print $self->name(), "\t";
	print $self->namespace(), "\t";
	print $self->def(), "\n";

	if ( $self->has_is_as() ) {
		foreach my $isaRef ( keys $self->get_is_as() ) {
			print "is_a:\t", $self->is_as()->[$isaRef], "\n";
			}
		}

	if ( $self->has_alt_ids() ) {
		foreach my $altIdRef ( keys $self->get_alt_ids() ) {
			print "alt_id:\t", $self->alt_ids()->[$altIdRef], "\n";
		}
	}
}

has 'id' => (
	is => 'ro',
	isa => 'Str',
	clearer => 'clear_id',
	predicate => 'has_id',
	);
has 'name' => (
	is => 'ro',
	isa => 'Str',
	clearer => 'clear_name',
	predicate => 'has_name',
	);
has 'namespace' => (
	is => 'ro',
	isa => 'Str',
	clearer => 'clear_namespace',
	predicate => 'has_namespace',
	);
has 'def' => (
	is => 'ro',
	isa => 'Str',
	clearer => 'clear_def',
	predicate => 'has_def',
	);
has 'is_as' => (
	is => 'ro',
	isa => 'ArrayRef[Str]',
	clearer => 'clear_is_as',
	predicate => 'has_is_as',
	);
has 'alt_ids' => (
	is => 'ro',
	isa => 'ArrayRef[Str]',
	clearer => 'clear_alt_ids',
	predicate => 'has_alt_ids',
	);
1;
