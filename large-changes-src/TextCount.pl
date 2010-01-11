#!/usr/bin/perl
use strict;
die "NEED 2 ARGS!!! name file" if @ARGV < 2;
my ($w,$e,$t) = read_file($ARGV[1]);
output_arff($ARGV[0],$w,$e,$t);


#count the words
sub read_file {
    open(my $fd, $_[0]);
    my %word_hash = ();
    my %tag_hash = ();
    my @elms = ();
    #my $line = <$fd>;
    while (my $line = <$fd> ) {
       chomp($line);
       next if $line =~ /^reason\s*|\s*mrid\s*|\s*count\s*|\s*log/;
       next if $line =~ /^#/;
       next if $line =~ /^[\-\+]+$/;
       my ($tags,$id,$size,$words) = split(/\|/,$line,4);
       next unless $tags;
       $size =~ s/\s+//g;
       my @tags = split(/\s+/,$tags);
       @tags = map { s/\?//g; $_ } @tags;
       foreach (@tags) { $tag_hash{$_}++ }
       $words =~ s/NEWLINE/\n/g;
       my @tokens = grep { /./ && !/^\s*$/ && /^[a-zA-Z0-9]+$/ } (split (/[\*\+\-\!\s\n\r\,\.\(\)\/\"\'\&]/,$words));
       my %subcount = ();
       foreach (@tokens) {           #maybe want to stem and clean up
           my $token = lc($_);
           $subcount{$token}++;
           $word_hash{$token}++;
       }       
       push @elms, {
                    tag => $tags[0],
                    tags => \@tags,
                    id => $id,
                    raw => $words,
                    size => $size,
                    counts => \%subcount
       };
    }
    return ( \%word_hash, \@elms, \%tag_hash );
}

#assumption - 1 tag
sub output_arff {
    my ($name,$word_hash,$elms,$tag_hash) = @_;
    my @features = sort keys %$word_hash;
    my @tags = sort keys %{$tag_hash};
    my $tag = join(",",@tags);
    print <<EOM;
\@RELATION $name
\@ATTRIBUTE class {$tag}
\@ATTRIBUTE size REAL
EOM
    foreach my $feature (@features) {
        print <<EOM;
\@ATTRIBUTE F_$feature REAL
EOM
    }
    print <<EOM;
\@DATA
EOM
    foreach my $elm (@$elms) {
        my $tag = $elm->{tag};
        my $size = $elm->{size};
        my $hash = $elm->{counts};
        my @elms = map { (exists $hash->{$_})?$hash->{$_}:0 } @features;
        print join(",",$tag,$size,@elms),$/;
    }
}
