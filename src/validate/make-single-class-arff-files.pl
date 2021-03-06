#!/usr/bin/perl
# first arg is an arff name in output/ (not extension)
# this is in perl because ARFF.pm exists
use strict;
use ARFF;

my @classifiers = slurp('weka-classifiers');


my $BASE="output";
mkdir($BASE);
my $tmp = "$BASE/tmp";
mkdir("$BASE/tmp");
my $project = $ARGV[0] || die "No Project Specified!";
my $arff_file = "$BASE/$project.arff";
my $arff = ARFF->new( filename => $arff_file );
my @attrs = $arff->get_attributes();
my @classes = grep {/^A_/} @attrs; # get our annotations!
#my @classnames = sort(@classes);

my @classnames = ();
my @arffs = ();
foreach my $class (@classes) {

    my $arff = $arff->copy(); # replace with a copy
    my $classname = $class;
    $classname =~ s/^A_//;
    warn $classname;
    my @drop_columns = grep { $_ ne $class } @classes;
    warn "Dropping: @drop_columns";
    $arff->drop_columns( @drop_columns  );
    #$arff is mutated
    my $ofile = "$BASE/tmp/$project.$classname.arff";
    warn "Writing $ofile";
    $arff->writeout( $ofile );
    push @classnames, $classname;
}

# make the makefile

open(MF,">","Makefile.$project");
my @reports = ();
foreach my $class (@classnames) {
    foreach my $classifier (@classifiers) {
        my $report = "$BASE/$project.$class.$classifier.txt";
        my $arfffile = "$BASE/tmp/$project.$class.arff";
	print MF "$report: ${arfffile}$/";
        print MF "\tsh -x weka-classifier.sh $classifier -i -t $arfffile -c last | tee $report$/";
        push @reports, $report;
    }
}
print MF "all: ".join(" ",@reports).$/;
close(MF);
	
	
sub slurp {
    open(SLURPFD,$_[0]) or die "can't open $_[0]";
    my @lines = <SLURPFD>;
    chomp(@lines);
    return @lines;
}


__DATA__
# This stuff does not run
# this was the old script

ATTRS=`egrep '^@ATTRIBUTE ' $BASE/$FILE.arff | wc -l`
WATTRS=`egrep '^@ATTRIBUTE W_' $BASE/$FILE.arff | wc -l`
AATTRS=`egrep '^@ATTRIBUTE A_' $BASE/$FILE.arff | wc -l`
AATTRSSTART=`expr $WATTRS + 1`
ATTRL=`seq $AATTRSSTART $ATTRS`
ALL=""
for file in $ATTRL
do
	ARFF=$BASE/tmp/$FILE.$file.arff 
	echo ${ARFF}: $BASE/$FILE.arff
	echo -e "\tjava" -cp weka-36.jar weka.filters.unsupervised.attribute.Remove -V -R 1-${WATTRS},$file -i $BASE/$FILE.arff -o ${ARFF}
	for classifier in `cat weka-classifiers`
	do
		REPORT=output/$FILE.$file.$classifier.txt 
		echo "$REPORT:" ${ARFF}
		echo -e "\tsh" -x weka-classifier.sh $classifier -i -t $ARFF -c last \| tee $REPORT
		ALL="$REPORT $ALL"
	done
done
echo "all: $ALL"

