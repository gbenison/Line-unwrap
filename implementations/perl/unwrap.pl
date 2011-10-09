#!/bin/env perl

use strict;

my $sentinel = 0;
my $previous_line;
my $result = "";

sub early_indent { # line next_line
    my $line = shift(@_);
    my $next_line = shift(@_);

    my @words = split(' ', $next_line);
    return (length ($line . " " . $words[0]) < length($next_line));
}

while (<>)
{
    my $this_line = $_;
    chomp $this_line;
    if ($sentinel)
    {
	if (($this_line eq "")
	    || ($previous_line eq "")
	    || ($this_line =~ /^[^A-Za-z0-9]/)
	    || early_indent($previous_line, $this_line))
	{ $result .= $previous_line . "\n"; }
	else {$result .= ($previous_line . " "); }
    }
    $previous_line = $this_line;
    $sentinel = 1;
}

print $result . "\n";
