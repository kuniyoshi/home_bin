#!/usr/bin/env perl
use 5.10.0;
use utf8;
use strict;
use warnings;
use open qw( :utf8 :std );
use Data::Dumper;
use List::Util qw( sum );

chomp( my @lines = <> );

my %result = count( @lines );
say Dumper \%result;

exit;

sub count {
    my @lines = @_;
    my %result = (
        lines => scalar( @lines ),
        words => sum( map { length } @lines ),
        paragraphs => scalar( grep { m{\A \z}msx } @lines ) + 1,
    );

    return %result;
}
