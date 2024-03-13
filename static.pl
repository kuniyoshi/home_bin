#!/usr/bin/perl
use Mojolicious::Lite;

push @{ app->static->paths }, ".";

# get '/' => sub {
#     my $c = shift;
#     $c->render(text => 'Hello World!');
# };

app->start;
