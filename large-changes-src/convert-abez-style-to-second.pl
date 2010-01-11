# Generate ARFF files from markup_report and markup_report.orig files
#reason|mrid|count|log
use strict;
use Data::Dumper;
use File::Basename;
use STBD;
use ARFF;
use TagMap;

my $LANG = 0;
my $MODULES = 1;
my $AUTHORS = 1;
if ($ARGV[0] eq "-bigtype") {
    shift @ARGV; # remove the arg because we're too cheap to use getopt like real men
    #ok do this
    # do the language analysis in this file
    # easier than joining
    $LANG = 1;
}
if ($ARGV[0] eq "-nomodules") {
    shift @ARGV; # remove the arg because we're too cheap to use getopt like real men
    #ok do this
    # do the language analysis in this file
    # easier than joining
    $MODULES = 0;
}
if ($ARGV[0] eq "-noauthors") {
    shift @ARGV; # remove the arg because we're too cheap to use getopt like real men
    #ok do this
    # do the language analysis in this file
    # easier than joining
    $AUTHORS = 0;
}



my ( $ANNOTATED_FILE, $DATAFILE, $OUTFILE1) = @ARGV;

die "OUTFILES NOT PROVIDED: 4 args ANNOTATEDFILE DATEFILE OUTFILEPREFIX1" unless $OUTFILE1;

my %hash = ();
my %authors = ();
my %types = ();
my %files = ();
my %dirs = ();
my %tags = ();
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
    addauthor($id,$author);
    addlog($id,$comment);
    addfile($id,$filename);
    addfiletype($id,STBD::file_type($filename));
    adddir($id,dirname($filename));
}
close($fd);

warn "Loaded!";

# this arff is with directory counts
# author
# size
my @keys = sort keys %hash;

# count the words
my %words = ();
if ($LANG) {
    foreach my $key (@keys) {
        my $h = $hash{$key};
        next unless $h->{logs};
        my $wh = process_comment( $h->{logs} );# || die "missing logs?? ".Dumper($h) );
        $h->{words} = $wh;
        while (my ($k,$v) =  each %{$wh}) {
            $words{$k} += $v;
        }
    }
}
my @words = sort keys %words;

my @tags = sort keys %tags;
my @types = sort keys %types;
my @dirs = sort keys %dirs;
my @authors = sort keys %authors;
my $ARFF = ARFF->new(relation => "Dir-based");
$ARFF->add_column('tag', "CLASS", (cleanupall(@tags)));
if ($AUTHORS) {
    $ARFF->add_column('author',"CLASS", (cleanupall(@authors)));
}
$ARFF->add_column('size',"REAL");
if ($MODULES) {
    foreach (@types) {
        $ARFF->add_column(cleanup($_),"REAL");
    }
    foreach (@dirs) {
        $ARFF->add_column(cleanup($_),"REAL");
    }
}
if ($LANG) {
    foreach (@words) {
        $ARFF->add_column(cleanup("F_".$_),"REAL");
    }
}


foreach my $key (@keys) {
    my $h = $hash{$key};
    my $tag = $h->{tag};
    my $author = $h->{author};
    my $size = $h->{count};
    my @omytypes = ();
    my @odirs = ();
    if ($MODULES) {
        @omytypes = map { $h->{type}->{$_} || 0 } @types;
        @odirs = map { $h->{dirs}->{$_} || 0 } @dirs;    
    }
    my @owords = ();
    if ($LANG) {
        @owords = map { $h->{words}->{$_} || 0 } @words;
    }
    my $auth = cleanup($author);
    if ($auth) {
        foreach my $tag (keys %{$h->{tags}}) {
            my @ourauthors = ();
            @ourauthors = ( cleanup($author) ) if $AUTHORS;
            $ARFF->add_row($tag, @ourauthors, $size, @omytypes, @odirs, @owords)
        }
    }
}

$ARFF->writeout("${OUTFILE1}.arff");

foreach my $tagname ( TagMap::tag_names() ) {
    my $mapfun = TagMap::get_map_fun_for( $tagname );
    my $tagfun = TagMap::get_tags_fun_for( $tagname );
    my @tags = &$tagfun();

    my $newarff = $ARFF->map_class( 'tag' , [ @tags ], $mapfun );
    $newarff->writeout( "${OUTFILE1}.${tagname}.arff" );
}



sub cleanupall {
    map { cleanup($_) } @_
}
sub cleanup {
    my ($file) = @_;
    $file =~ s/[\s,]/_/g;
    return $file;
}

sub process_comment {
    return "" unless ref $_[0];
    my @logs = @{$_[0]};
    my %uniq = ();
    foreach (@logs) {
        $uniq{$_}++;
    }
    my @lines = keys %uniq;
    #my @lines = sort keys %uniq;
    foreach (@lines) { s/NEWLINE/ /g; }
    my %hash = ();
    foreach my $words (@lines) {
        my @tokens = grep { /./ && !/^\s*$/ && /^[a-zA-Z0-9]+$/ } (split (/[\*\+\-\!\s\n\r\,\.\(\)\/\"\'\&]/,$words));
        $hash{lc($_)}++ foreach @tokens;
    }
    return \%hash;
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
    $tags{$tag}++;
    $hash{$id}->{tags}->{$tag}++;
}
sub addfile {
    my ($id,$tag) = @_;
    $files{$tag}++;
    $hash{$id}->{files}->{$tag}++;
}
sub adddir {
    my ($id,$tag) = @_;
    $dirs{$tag}++;
    $hash{$id}->{dirs}->{$tag}++;
}
sub addauthor {
    my ($id,$author) = @_;
    $authors{$author}++;
    #$hash{authors}->{$author}++;
    $hash{$id}->{author} = $author;
}

sub addfiletype {
    my ($id, $type) = @_;
    $types{$type}++;
    $hash{$id}->{type}->{$type}++;
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
