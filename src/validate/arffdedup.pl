#!/usr/bin/perl
use strict;
use ARFF;
my $filename = $ARGV[0];
warn "$filename -> $filename";
my $arff = ARFF->new( filename => $filename );
$arff->drop_duplicate_columns();
$arff->writeout( $filename );
