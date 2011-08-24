#!/usr/bin/perl
use strict;
use ARFF;
my $filename = $ARGV[0];
my $out = $ARGV[1];
$out = ($out)?$out:"$filename.csv";
warn "$filename -> $out";
my $arff = ARFF->new( filename => $filename );
my @attrs = $arff->get_attributes();
$arff->writeout_csv( $out );
