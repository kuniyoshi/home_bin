#!/usr/bin/env perl
use 5.10.0;
use utf8;
use strict;
use warnings;
use open qw( :utf8 :std );
use Data::Dumper;
use Time::HiRes qw( ualarm sleep gettimeofday tv_interval );
use Readonly;

Readonly my $MAX_WATING_NEXT_MICRO_SECONDS => 100_000;

$|++;

my $last;

while ( 1 ) {
    local $SIG{ALRM} = sub { say $last if $last };
    ualarm $MAX_WATING_NEXT_MICRO_SECONDS;

    my $line = readline;

    last
        unless defined $line;

    chomp( $last = $line );
}

say $last
    if $last;


exit;

