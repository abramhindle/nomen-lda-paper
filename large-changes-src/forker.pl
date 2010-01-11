#!/usr/bin/perl
use Parallel::ForkManager;
use strict;

my $processes = shift @ARGV || 4;
my $pm = Parallel::ForkManager->new($processes);

while(my $line = <>) {
    chomp($line);
    warn $line;
    $pm->start and next;
    system($line);
    $pm->finish;
}
$pm->wait_all_children;
