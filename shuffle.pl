#!/usr/bin/env perl
use 5.10.0;
use utf8;
use strict;
use warnings;
use open qw( :utf8 :std );
use Data::Dumper;
use List::Util qw( shuffle );

chomp( my @lines = <> );

@lines = shuffle @lines;

print map { $_, "\n" } @lines;

exit;

