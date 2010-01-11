#!/usr/bin/perl
# Our goal here is to generate some distributions
# of tags per project
use strict;
use TagMap;
use LargeChanges;


#ASSUME ALL FILES ON THE COMMANDLINE
#ARE FOR 1 PROJECT
my $ProjectName = shift @ARGV;
my $proportional = ($ProjectName eq "Proportional");
my $proportional_flag = 0;
if ($ProjectName eq '-p') {
    $ProjectName = shift @ARGV;
    $proportional = 1;
    $proportional_flag = 1;
}
warn "$ProjectName";

my @files = @ARGV;
my $output_dir = "./reports";
mkdir $output_dir;

if ($proportional) {
    proportional_run($proportional_flag);
} else {
    normal_run();
}

sub proportional_run {
    my $is_project = $_[0];
    my @hashes = load_files(@files);
    my @tag_funs = TagMap::get_tag_function_tuples();
    my @dists = map {
	my ($name,$f1,$f2) = @$_;
        warn "Calculating Proportional for $name";
        my @dists = map {
            my $proj = $_;
            my $revs = count_revisions($proj);
            my $dist = get_distribution($name,$f1,$f2,$proj);
            my $normal = hash_float_div($dist, $revs);
            $normal
            } @hashes;
        warn "sum hash";
        my $distsum = sum_hashes(@dists);
        my $n_dists = scalar @dists;
        my $distsum = hash_float_div($distsum, $n_dists);

	[$name, $distsum ] 
        } @tag_funs;
    foreach my $dist (@dists) {
	my ($name,$dist) = @$dist;
        $name = ($is_project)?"proportional-${name}":$name;
	print_distribution($name,$dist);
	print_sorted_distribution($name,$dist);
	#print_sorted_percent_distribution($name,$dist,$revisions);
    }
}
sub normal_run {
    my @hashes = load_files(@files);
    my $project_hash = 
        ($proportional)?
        get_hash_of_hashes_normalized(@hashes) :
        get_hash_of_hashes(@hashes);

    #[name,mapfun,tagslistfun]
    my $revisions = scalar(keys %$project_hash);
    
    {
        open(my $fd,'>',$output_dir."/".$ProjectName."-revision-count.txt");
        print $fd "$revisions$/";
        close($fd);
    }


    my @tag_funs = TagMap::get_tag_function_tuples();

    my @dists = map {
	my ($name,$f1,$f2) = @$_;
	[$name, get_distribution($name,$f1,$f2,$project_hash)]
        } @tag_funs;

    foreach my $dist (@dists) {
	my ($name,$dist) = @$dist;
	print_distribution($name,$dist);
	print_sorted_distribution($name,$dist);
	print_sorted_percent_distribution($name,$dist,$revisions);
    }
    
}






sub print_distribution {
	my $name = shift;
	my $dist = shift;
	my @tags = keys %$dist;
	my @tags = sort(@tags);
	open(my $fd,'>',$output_dir."/".$ProjectName."-".$name."-report.txt");
	foreach my $tag (@tags) {
		print $fd "$tag\t|\t".$dist->{$tag}."$/";
	}
	close($fd);
}
sub print_sorted_distribution {
	my $name = shift;
	my $dist = shift;
	my @tags = keys %$dist;
	my @tags = sort {$dist->{$b} <=> $dist->{$a}; } @tags;
	open(my $fd,'>',$output_dir."/".$ProjectName."-".$name."-report-sorted.txt");
	foreach my $tag (@tags) {
		print $fd "$tag\t|\t".$dist->{$tag}.$/;
	}
	close($fd);
}
sub print_sorted_percent_distribution {
	my $name = shift;
	my $dist = shift;
	my $total = shift;
	my @tags = keys %$dist;
	my @tags = sort {$dist->{$b} <=> $dist->{$a}; } @tags;
	open(my $fd,'>',$output_dir."/".$ProjectName."-".$name."-report-sorted-percent.txt");
	foreach my $tag (@tags) {
		print $fd "$tag\t|\t".($dist->{$tag}/$total).$/;
	}
	close($fd);
}
sub get_distribution {
	my ($name,$tag_map,$tags_fun,$project) = @_;
	my @tags = &$tags_fun();
	my %dist = ();
	foreach my $tag (@tags) {
            if (!$tag) {
                warn "BAD TAG FOUND \"$tag\" - $name ".(defined($tag));
            } else {
                $dist{$tag} = 0;
            }
	}
        # was a counting bug here
	while (my ($id,$vals) = each %$project) {
            my @mapped = map { &$tag_map($_) } (@$vals);
            my @tags = uniq(@mapped);
            for my $tag (@tags) {
                if ($tag) {
                    $dist{$tag}++;
                }
            }
	}
	return \%dist;
}
sub uniq {
    my %h = ();
    foreach (@_) {
        $h{$_}++;
    }
    return keys %h;
}
sub load_files {
	my @files = @_;
	my @hashes = map { my ($hash) = LargeChanges::load_file($_); $hash} @files;
	return @hashes;
}
sub get_hash_of_hashes {
	my @hashes = @_;
	my $super_hash = {};
	foreach my $hash (@hashes) {
		while( my ($id,$vals) = each %$hash ) {
			foreach my $tag (@$vals) {
				LargeChanges::push_hash($super_hash,$id,$tag);
			}
		}
	}
	return $super_hash;
}
sub sum_hashes {
    my @hashes = @_;
    my %out = ();
    foreach my $hash (@hashes) {
        while(my ($key,$val) = each %$hash) {
            #yeah adding to undef
            $out{$key} += $val;
        }
    }
    return \%out;
}
sub count_tags {
    my $dist = $_[0];
    my $total = 0;
    while(my ($key,$val) = %$dist) {
        $total += $val;
    }
    return $total;
}
sub count_revisions {
    my $dist = $_[0];
    return scalar(keys %$dist);
}

sub normalize_dist {
    my $dist = $_[0];
    my $total = count_revisions($dist);
    return hash_float_div($dist,$total);
}
sub hash_float_div {
    my ($hash,$n) = @_;
    my %out = ();
    while(my ($key,$val) = each %$hash) {
        my $v = ($val / (1.0 * $n));
        if ($v > 1.0) {
            warn "$ProjectName: $key $val $v > $n!";
        }
        $out{$key} = $v;
    }
    return \%out;
}
