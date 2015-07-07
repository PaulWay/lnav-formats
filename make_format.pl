#!/usr/bin/perl -w

use warnings;
use strict;

my $header = '{
	"NEW_log" : {
		"title"			: "NEW log format",
		"description"	: "Log format used by NEW",
		"url"			: "http://NEW",
		"regex" : {
			"debug_line"	: {
				"pattern" : "^(?<timestamp>\\d{4}/\\d{2}/\\d{2} \\d{2}:\\d{2}:\\d{2}(?:\\.\\d+)?) (?<body>.*)$"
			}
		},
		"value" : {
			"pid"	: { "kind" : "integer", "identifier" : true },
			"body"	: { "kind" : "string" }
		},
		"sample" : [
';
my $sample_prefix = '			{
				"line" 	: "';
my $sample_suffix = '"
			}';
my $footer = '
		]
	}
}
';

# Read lines in, strip, and escape double quotes and backslashes.
my @lines;
while (<>) {
	chomp; tr/\r//d;
	s{\\}{\\\\}g;
	s{"}{\\"}g;
	push @lines, $_;
}

# Print the template;
print $header;
print join(",\n", map { $sample_prefix . $_ . $sample_suffix } @lines);
print $footer;
