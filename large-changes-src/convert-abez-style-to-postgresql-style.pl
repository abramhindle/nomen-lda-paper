#reason|mrid|count|log
use strict;
my ( $ANNOTATED_FILE, $DATAFILE ) = @ARGV;

my %hash = ();
open(my $fd, $ANNOTATED_FILE);
while(<$fd>) {
    chomp;
    my ($id,$tag) = split(/\|/,$_,2);
    addtag($id,$tag);
}
close($fd);
open(my $fd, $DATAFILE);
while(<$fd>) {
    chomp;
    my ($id,$filename,$author,$versiom,$ladd,$ldel,$comment) = split(/\|/,$_,7);
    #warn "my ($id,$filename,$author,$versiom,$ladd,$ldel,$comment)";
   
    $id =~ s/^\s*//;
    $id =~ s/\s*$//;
    count($id);
    addlog($id,$comment);
    
}
close($fd);

while(my ($key,$val) = each %hash) {
    my @tags = sort keys %{$val->{tags}};
    my $comment = process_comment($val->{logs});
    foreach my $tag (@tags) {
       print join("|",($tag,$key,$val->{count},$comment)).$/;
    }
}

sub process_comment {
    return "" unless ref $_[0];
    my @logs = @{$_[0]};
    my %uniq = ();
    foreach (@logs) {
        $uniq{$_}++;
    }
    my $o =  join("NEWLINE",sort keys %uniq);
    return $o;
}
sub addlog {
    my ($id,$log) = @_;
    $hash{$id}->{logs} = [] unless exists $hash{$id};
    push @{$hash{$id}->{logs}}, (split("NEWLINE",$log));
}
sub count {
    my ($id) = @_;
    $hash{$id}->{count}++;
}
sub addtag {
    my ($id,$tag) = @_;
    $hash{$id}->{tags}->{$tag}++;
}


__DATA__

A ANNOTATED_FILE looks like this 
agurtovoy:2001-09-26 09:48:35 +0000_19|init
agurtovoy:2001-09-26 09:48:35 +0000_19|add
agurtovoy:2001-09-26 09:48:35 +0000_19|fea
agurtovoy:2002-02-19 11:41:51 +0000|doc
agurtovoy:2002-04-01 07:29:41 +0000_70|branch
agurtovoy:2002-04-13 06:03:43 +0000|doc
agurtovoy:2002-04-13 06:03:43 +0000|add
agurtovoy:2002-07-18 03:37:02 +0000|fea
agurtovoy:2002-07-18 03:37:02 +0000|add
agurtovoy:2002-07-18 03:37:02 +0000|brnch
agurtovoy:2002-07-18 03:39:46 +0000_51|fea
agurtovoy:2002-07-18 03:39:46 +0000_51|add


A DATAFILE Looks like this

agurtovoy:2001-09-26 09:48:35 +0000_19|boost/boost/mpl/wrapper/unary_predicate.hpp|agurtovoy|1.1.2.1|41|0|initial CVS checkinNEWLINE
	 agurtovoy:2001-09-26 09:48:35 +0000_19|boost/boost/mpl/while_true.hpp|agurtovoy|1.1.2.1|142|0|initial CVS checkinNEWLINE
	 agurtovoy:2001-09-26 09:48:35 +0000_19|boost/boost/mpl/value_range/tags.hpp|agurtovoy|1.1.2.1|33|0|initial CVS checkinNEWLINE
	 agurtovoy:2001-09-26 09:48:35 +0000_19|boost/boost/mpl/value_range/size.hpp|agurtovoy|1.1.2.1|48|0|initial CVS checkinNEWLINE
	 agurtovoy:2001-09-26 09:48:35 +0000_19|boost/boost/mpl/value_range/iterator.hpp|agurtovoy|1.1.2.1|45|0|initial CVS checkinNEWLINE
