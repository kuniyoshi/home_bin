#!/usr/bin/env perl -s
use 5.10.0;
use utf8;
use strict;
use warnings;
use open qw( :utf8 :std );
use Data::Dumper;

our $s = q{, };

chomp( my @lines = <> );
say join $s, @lines;

exit;

