package Bencher::Scenario::EnsuringAllPatternsInString;

use 5.010001;
use strict;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

my @ajrand = qw(f e j b a i g d c h);
my @bjrand = qw(f e j b   i g d c h);

our $scenario = {
    summary => 'Ensuring all patterns are in a string',
    description => <<'MARKDOWN',

This scenario is inspired by <http://perlmonks.org/?node_id=1153410>. I want to
know how much faster/slower using the single regex with look-around assertions
is compared to using multiple regex.

As I expect, the single_re technique becomes exponentially slow as the number of
patterns and length of string increases.

MARKDOWN
    participants => [
        {
            name => 'single_re',
            summary => 'Uses look-around assertions',
            code_template => <<'MARKDOWN',
state $re = do {
    my $re = join "", map {"(?=.*?".quotemeta($_).")"} @{<patterns>};
    qr/$re/;
};
<string> =~ $re;
MARKDOWN
        },
        {
            name => 'multiple_re',
            code_template => <<'MARKDOWN',
state $re = [map {my $re=quotemeta; qr/$re/} @{<patterns>}];
for (@$re) { return 0 unless <string> =~ $_ }
1;
MARKDOWN
        },
    ],
    datasets => [
        {
            name => 'dataset',
            args => {
                'patterns@' => {
                    '2short'  => ['a','b'],
                    '5short'  => ['a'..'e'],
                    '10short' => ['a'..'j'],
                    '2long'   => [map {$_ x 20} 'a','b'],
                    '5long'   => [map {$_ x 20} 'a'..'e'],
                    '10long'  => [map {$_ x 20} 'a'..'j'],
                },
                'string@' => {
                    'match_short'    => join("", map {$_ x 20} @ajrand),
                    'match_medium'   => join("", map {$_ x 200} @ajrand),
                    'match_long'     => join("", map {$_ x 2000} @ajrand),
                    'nomatch_short'  => join("", map {$_ x 20} @bjrand),
                    'nomatch_medium' => join("", map {$_ x 200} @bjrand),
                    'nomatch_long'   => join("", map {$_ x 2000} @bjrand),
                },
            },
        },
    ],
};

1;
# ABSTRACT:
