# This program will take the first class element, assume it 
# is a "large change" tag and map it to the tag you chose

use ARFF;
use TagMap;
use strict;

my ($filename, $outputfilename, $whichclass) = @ARGV;

die "Not enough arguements my (\$filename, \$outputfilename, \$whichclass) = \@ARGV;" unless @ARGV >= 3;

$whichclass = $whichclass || "detail";


my $mapfun = TagMap::get_map_fun_for($whichclass);
die "Couldn't find map fun" unless ($mapfun);

sub mapfun {
    &$mapfun(@_);
}
my $tagfun = TagMap::get_tags_fun_for($whichclass);
die "Couldn't find tag fun" unless ($tagfun);
my @tags = &$tagfun();

my $arff = ARFF->new( filename => $ARGV[0]); #parse our ARFF

$arff->mutate_class( 'class' , [ @tags ], $mapfun );

#my $data = $arff->data();
#$arff->change_type('class','CLASS',(map {ARFF::class_filter($_)} @tags));
#my @out = ();
#foreach my $elm (@$data) {
#    my $e = ARFF::class_filter(mapfun($elm->[0]));
#    unless (defined $e) {
#        warn "[$e] $elm->[0] NOT DEFINED??? ";
#        next;
#    }
#    $elm->[0] = $e;
#    push @out,$elm;
#}
#$arff->data(\@out);

$arff->writeout($outputfilename);
