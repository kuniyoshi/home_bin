#!/usr/bin/perl -s
use 5.10.0;
use utf8;
use strict;
use warnings;
use open qw( :utf8 :std );
use Data::Dumper;

our $t;
our $h;

die usage( )
    if $h;

my @representations = !$ENV{IFS} ? @ARGV : map { split m{$ENV{IFS}} } @ARGV;

for my $r ( @representations ) {
    my $number = eval $r;

    my $to = $t || "h";

    if ( $to eq "d" ) {
        say $number;
    }
    elsif ( $to eq "h" ) {
        say sprintf "%x", $number;
    }
}

exit;

sub usage {
    return <<END_USAGE;
usage: $0 <-h | [-t=<d|h>] <representations>>
END_USAGE
}

