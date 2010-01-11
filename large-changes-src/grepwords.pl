while(<>) {
	chomp;
	my @matches = ($_ =~ /F_([^ ]+)/);
	print $_,$/ foreach @matches;
}
