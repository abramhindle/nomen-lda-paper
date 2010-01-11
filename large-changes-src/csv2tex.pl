#!/usr/bin/perl
my $file = pop @ARGV;
my @schema = @ARGV;
my @schema = map {trim($_)} @ARGV;
open(my $fd,$file) or die "Ugh $file no!";
while(<$fd>) {
	chomp;
	my @csv = split(/\s*\|\s*/,$_);
        @csv = map { trim($_) } @csv;
        if (@csv && $csv[0]) {
            print join("\t&\t",schema_filter(@csv))," \\\\$/";
        }
}
sub trim {
	my $a = shift;
	$a =~ s/^\s*//;
	$a =~ s/\s*$//;
	return $a;
}
sub schema_filter {
	unless (@schema) {
		return @_;
	} 
	my @csv = @_;
	my @out = ();
	for(my $i = 0; $i < @csv; $i++) {
		unless ($schema[$i]) {
			push @out, $csv[$i];
		} else {
			push @out,
				our_sprintf($schema[$i],$csv[$i]);
		}
	}
	return @out;
}
sub our_sprintf {
    my ($template,$csv_elm) = @_;
    if ($template eq '%%') {
        return sprintf('%0.1f \%',($csv_elm * 100));
    } else {
        return sprintf($template,$csv_elm);
    }
}
