#!/usr/bin/perl -w

use warnings;
use strict;
use autodie;

use Getopt::Long;

my $format_name = 'NEW';
my $output_file = '-';
GetOptions(
	'name|n=s'		=> \$format_name,
	'output|o=s'	=> \$output_file,
);

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

# Replace format name if necessary
if ($format_name ne 'NEW') {
	$header =~ s{NEW}{$format_name}go;
};

# Read lines in, strip, and escape double quotes and backslashes.
my @lines;
while (<>) {
	chomp; tr/\r//d;
	s{\\}{\\\\}g;
	s{"}{\\"}g;
	push @lines, $_;
}

# Open output, or stdout if requested
my $ofh;
if ($output_file eq '-') {
	$ofh = *STDOUT;
} else {
	open $ofh, '>', $output_file;
}

# Print the template;
print $ofh $header;
print $ofh join(",\n", map { $sample_prefix . $_ . $sample_suffix } @lines);
print $ofh $footer;

close $ofh;
