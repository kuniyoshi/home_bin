#!/usr/bin/env perl -s
use 5.10.0;
use utf8;
use strict;
use warnings;

our $ext;
our $d;
our $h;

my $name = shift;

die usage( )
    if $h;

if ( defined $ext ) {
    $name = "$name.$ext";
}
else {
    $name = "$name.*";
}

my $directory = defined $d ? $d : q{.};

chomp( my @files = `find $directory -name '$name'` );

if ( @files > 1 ) {
    warn "Several files found\n";
    warn map { $_, "\n" } @files;
    exit;
}

if ( !@files ) {
    warn "No file[$name] found.\n";
    exit;
}

my @args = ( ( $ENV{PAGER} || "less" ), $files[0] );

warn "Show file:\t$files[0]\n";

exec { $args[0] } @args;

sub usage {
    return <<END_USAGE;
usage: $0 [-ext=<extension>] [-d=<directory>] <filename>
    extension: specifies extension to show
    directory: specifies to search from where
    filename: name of file which is wanted to show
END_USAGE
}
