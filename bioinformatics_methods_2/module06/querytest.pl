#!/usr/bin/perl
#querytest.pl
use warnings;
use strict;
use DBI;

# A script that prompts the user for a GO term ID, queries the term table
# for that ID, and displays the name. Tested successfully on GO ID = 42952
#
# Example Useage
# ==============
#
# $ ./querytest.pl
#
# Enter a valid GO term identifier: 42952<ENTER>
# gliotoxin biosynthetic process
#

# Prompt user for a GO term ID.
print "Enter a valid GO term identifier: ";
chomp ( my $GO_ID = <STDIN> );

# If no input then exit gracefully.
exit 0 if ( $GO_ID eq "" );

my ($dbh, $sth, $name, $id);

# Instantiate a connection to local mySQL database for GO terms.
$dbh = DBI->connect(
    'dbi:mysql:go',
    'valentine.c',
    'password') ||
    die "Error opening database: $DBI::errstr\n";

# Prepare a mySQL query of the database.
$sth = $dbh->prepare("SELECT name from term where id = $GO_ID;") ||
    die "Prepare failed: $DBI::errstr\n";

# Execute that query.
$sth->execute() ||
    die "Couldn't execute query: $DBI::errstr\n";

# Print all entries our query returns. In this case just GO term names.
while ( my $name = $sth->fetchrow_array ) {
    print "$name\n";
}

# Finish this mySQL query and detach from the database.
$sth->finish();
$dbh->disconnect || die "Failed to disconnect\n";
