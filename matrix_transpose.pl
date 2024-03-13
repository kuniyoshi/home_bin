#!/usr/bin/env perl
use 5.10.0;
use utf8;
use strict;
use warnings;
use open qw( :utf8 :std );
use Data::Dumper;

my @paragraphs;
my @sentences;

while ( <DATA> ) {
    chomp( my $line = $_ );

    if ( $line =~ m{\A \s* \z}msx ) {
        push @paragraphs, [ @sentences ];
        @sentences = ( );

        next;
    }

    push @sentences, $line;
}

push @paragraphs, [ @sentences ];
@sentences = ( );

print map { $_, "\n" }
      map { join "\t", @{ $_ } }
      @paragraphs;

exit;

__DATA__
体重
体脂肪率
内臓脂肪
骨格筋率
体年齢
基礎代謝
BMI

3/19
58.4
17.0
6
40.0
28
1469
21.3

3/20
57.2
19.6
5
37.3
29
1431
20.9

3/21
57.1
19.5
5
37.8
29
1430
20.8

3/22
56.5
19.8
5
36.9
29
1414
20.6

3/23
56.4
18.8
5
38.3
27
1422
20.6

3/24
56.6
19.3
5
37.8
28
1422
20.7

3/25
57.1
18.1
5
39.1
27
1440
20.8

3/26
56.3
19.4
5
37.5
28
1415
20.6

3/27
56.1
19.2
5
37.7
28
1413
20.5

3/28
55.7
18.0
5
39.1
26
1416
20.3
