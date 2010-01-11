package LargeChanges;
use strict;

{
    my @projects = ();
    sub get_projects {
        return @projects if (@projects);
        open(my $fd, "projects") or die "NO projects FILE!";
        chomp(@projects = <$fd>);
        close($fd);
        return @projects;
    }
}


sub load_file {
	my $file = shift;
	warn "Opening $file";
	#$fd will be closed when it goes out of scope
	open(my $fd,$file) or die "Couldn't open $file";
	my $readln;
	my $push_back;
	{
		#hurrf, buffered input reader
		my @buffer = ();
		$readln = sub {
			if (@buffer) {
				my $ret = shift @buffer;
				chomp($ret);
				return $ret;
			} else {
				my $line = <$fd>;
				chomp($line);
				return $line;
			}
		};
		$push_back = sub {
			my $line = shift;
			push @buffer, $line;
		};
	}
	my $line;
	while( ($line = &$readln()) && defined $line) {
		if (	$line =~ /reason\s*\|\s*mrid/ ||
			$line =~ /^[\-\+]+$/ ) {
			return daniel_reader($readln);	
		} elsif ($line =~ /^[a-zA-Z0-9]+\;/) {
			return daniel_alt_reader($readln);	
		} elsif ($line =~ /\|/) {
			&$push_back($line);
			return abram_reader($readln);
		} else {
			warn "I don't know this line: $line";
		}
	}
	die "Error, could not read file";
}
#push a value onto a hash of lists
sub push_hash {
	my ($hash,$key,$val) = @_;
	if (exists $hash->{$key}) {
		push @{$hash->{$key}}, $val;
	} else {
		$hash->{$key} = [$val];
	}
}
sub daniel_reader {
	warn "daniel";
	my $readln = shift;
	return abstract_reader(1,0,$readln,"|");
}
sub daniel_alt_reader {
	warn "daniel alt";
	my $readln = shift;
	return abstract_reader(2,0,$readln,";");
}
sub abram_reader {
	warn "abram";
	my $readln = shift;
	return abstract_reader(0,1,$readln,"|");
}
#Very simple CSV file reader
sub abstract_reader {
	# the index of the ID
	my $key_index = shift;
	# the index of the tag
	my $val_index = shift;
	# our read-line function
	my $readln = shift;
	# the CSV char to split on
	my $split_char = shift;
	my $hash = {};
	my @ids = ();
	my $line;
	while( ($line = &$readln()) && defined $line) {
		my @a = split(/\Q${split_char}\E/,$line);
		my $key = trim($a[$key_index]);
		my $tag = trim($a[$val_index]);
		my $tag = process_tag($tag);
		push_hash($hash,$key,$tag) if $key;
		push @ids,$key;
	}
	return ($hash,\@ids);
}
sub process_tag {
	my $tag = shift;
	$tag =~ s/\?$//;
	return $tag;
}
sub trim {
	my $a = shift;
	$a =~ s/^\s*//;
	$a =~ s/\s*$//;
	return $a;
}

1;
