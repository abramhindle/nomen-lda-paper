while(<>) {
	chomp;
	my @matches = ($_ =~ /W_([^ ]+)/);
	print $_,$/ foreach @matches;
}
