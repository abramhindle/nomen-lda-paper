#!/usr/bin/perl
use strict;
use MulanParser;
use Fatal qw(open close);

my $file = $ARGV[0];
{
    my $fd;
    open( $fd, $file );
    my @lines = <$fd>;
    my $h = MulanParser::mulan_parser( @lines );
    my @learners = sort keys %$h;
    my @rows = sort keys %{$h->{$learners[0]}};
    my $lt = LatexTable->create_table( rownames=>\@rows, colnames=> \@learners);
    foreach my $learn (@learners) {
        foreach my $metric (@rows) {
            $lt->set_value($learn, $metric, $h->{$learn}->{$metric});
        }
    }
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

