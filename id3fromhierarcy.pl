#!/usr/bin/perl
use 5.10.0;
use utf8;
use strict;
use warnings;
use open qw( :utf8 :std );
use Data::Dumper;
use Readonly;
use Encode qw( decode );
use Encode::UTF8Mac;
use Path::Class qw( dir );
use List::MoreUtils qw( true );
use MP3::Tag;
use ID3::FromHierarchy;

Readonly my %FRAME => (
    genre  => "TCON",
    artist => "TPE1",
    album  => "TALB",
    track  => "TRCK",
    title  => "TIT2",
);
Readonly my $DRY_RUN => 0;

MP3::Tag->config( write_v24 => 1 );

my $year = $ENV{MP3TAG_YEAR};
my $root = dir( "." );

my @target_genres = @ARGV
    or die "dir required.";

my $parser = ID3::FromHierarchy->new;

foreach my $genre ( grep { $_->is_dir } $root->children ) {
    next
        unless true { $_ eq $genre->relative( $root ) } @target_genres;

    say "### ", decode( "utf-8-mac", $genre->relative( $root ) );

    foreach my $artist ( grep { $_->is_dir } $genre->children ) {
        say "--- ", decode( "utf-8-mac", $artist->relative( $genre ) );

        foreach my $mp3 ( grep { !$_->is_dir } $artist->children ) {
            say "--- --- ", decode( "utf-8-mac", $mp3->relative( $artist ) );

            my %tag = eval {
                $parser->parse( decode( "utf-8-mac", $mp3->relative( $root ) ) )
            };

            if ( my $e = $@ ) {
                warn $e
                    and next;
            }

            $tag{year} = $year
                if $year;

            print map { "--- --- --- $_: $tag{$_}\n" } grep { defined $tag{ $_ } } keys %tag;

            update_id3( $mp3, %tag );
        }

        foreach my $album ( grep { $_->is_dir } $artist->children ) {
            say "--- --- ", decode( "utf-8-mac", $album->relative( $artist ) );

            foreach my $mp3 ( grep { !$_->is_dir } $album->children ) {
                say "--- --- --- ", decode( "utf-8-mac", $mp3->relative( $album ) );

                my %tag = eval {
                    $parser->parse( decode( "utf-8-mac", $mp3->relative( $root ) ) );
                };

                if ( my $e = $@ ) {
                    warn "!!! failed.[$e]"
                        and next;
                }

                print map  { "--- --- --- --- $_: $tag{$_}\n" }
                      grep { defined $tag{ $_ } }
                      keys %tag;

                update_id3( $mp3, %tag );
            }
        }
    }
}

exit;

sub update_id3 {
    my( $file, %tag ) = @_;
    my $year = delete $tag{year};
    my $mp3 = MP3::Tag->new( $file );

    return
        if $DRY_RUN;

    $mp3->{ID3v1}->remove_tag
        if exists $mp3->{ID3v1};
    $mp3->{ID3v2}->remove_tag
        if exists $mp3->{ID3v2};

    $mp3->new_tag( "ID3v2" );

    foreach my $key ( keys %tag ) {
        $mp3->{ID3v2}->add_frame( $FRAME{ $key }, $tag { $key } );
    }

    $mp3->year( $year );

    $mp3->{ID3v2}->write_tag;
    $mp3->close;

    return;
}

