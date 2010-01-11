#!/usr/bin/perl
# All we're doing here is getting a sorted list of tags
use strict;
use LargeChanges;


my %tags = ();
my $total_ids = 0;
for my $file (@ARGV) {
	my ($hash,$ids) = LargeChanges::load_file($file);
	$total_ids += scalar(keys %$hash);
	while(my ($key,$val) = each %$hash) {
		foreach my $v (@$val) {
			$tags{$v}++;
		}
	}
}
my @tags = keys %tags;
@tags = sort(@tags);
print join($/,@tags),$/;
