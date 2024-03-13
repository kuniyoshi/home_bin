#!/usr/bin/env perl
use 5.10.0;
use utf8;
use strict;
use warnings;
use open qw( :utf8 :std );
use Data::Dumper;
use bigint;

my $a = shift;
my $b = shift;

my $result = 1;
$result *= $a - $_
    for 0 .. ( $b - 1 );
$result /= $b - $_
    for 0 .. ( $b - 1 );

say $result;


exit;

