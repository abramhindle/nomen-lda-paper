#!/usr/bin/perl
use strict;
use MulanParser;
use Fatal qw(open close);
use LatexTable;
use Data::Dumper;

MulanParser::test();

my $file = $ARGV[0];
{
    my $fd;
    open( $fd, $file ) or die "$file not found!";
    my @lines = <$fd>;
    close($fd);
    my $h = MulanParser::mulan_parser( @lines );
    my @learners = sort keys %{$h};
    # warn "Learners: ".join(" , ",@learners);
    my @rows = sort keys %{$h->{$learners[0]}};
    my $lt = LatexTable::create_table( rownames=>\@rows, 
                                       colnames=> \@learners
                                     );
    print Dumper($lt);

    my @arows = ();
    foreach my $metric (@rows) {
        my @nrow = ();
        foreach my $learn (@learners) {
            my $v = $h->{$learn}->{$metric};
            push @nrow, $v;
            #warn "$learn $metric $v";
            #$lt->set_value($learn, $metric, $v);
        }
        push @arows, \@nrow;
    }
    $lt->rows(\@arows);
    
    print Dumper($lt);
    my $ltt = $lt->layout();
    my $lttt = $lt->transpose()->layout();
    my $fd;
    open($fd, ">", "$file.tex");
    print $fd $ltt;
    close($fd);
    open($fd, ">", "$file.transpose.tex");
    print $fd $lttt;
    close($fd);
}

