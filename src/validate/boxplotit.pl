#!/usr/bin/perl
use strict;
use Boxplot;
use XML::LibXML; # this is a similar lib to lxml


for my $file (@ARGV) {
    warn $file;
    my $parser = XML::LibXML->new;
    my $doc = $parser->parse_file( $file );
    my @stacked = $doc->getElementsByTagName('stacked_boxplot');
    my @notstacked = $doc->getElementsByTagName('boxplot');
    my @column_names = $doc->getElementsByTagName('column_name');
    my @column_names = map { $_->nodeValue } @column_names;
    my ($plot_name) = $doc->getElementsByTagName('plot_name');
    $plot_name = $plot_name->$nodeValue;
    my @rows;
    { 
        my ($rows) = $doc->getElementsByTagName('rows');
        @rows = map { 
            # make an array ref of values per row
            [ split(/[\s\t]+/, $_)  ] 
        } (split(/[\r\n]+/,$rows->nodeValue())); #split by newline
    }
    my @rownames;
    if (@notstacked) {
        @rownames = ( $plot_name );
    } elsif (@stacked) {
        @rownames = $doc->getElementsByTagName('column_name');
        @rownames = map { $_->nodeValue } @column_names;
    } else {
        die "Neither Stacked nor not stacked";
    }
    
    # now we have to make a file for the data?
    


    my $boxplot = Boxplot->new();

    #set column names! 0 to n
    $boxplot->column_labels( @column_names  );
    $boxplot->preamble("set key below");
    $boxplot->plot_file_output("$file.plot");
    $boxplot->data_file_output("$file.dat");
    $boxplot->output("$file.eps");
    $boxplot->set_eps_terminal();
    #$boxplot->add_data_files(@file_map);
    $boxplot->add_data_rows(zip(@rownames, @rows));
    $boxplot->plot_it();

    $boxplot->plot_file_output("$file.prop.plot");
    $boxplot->data_file_output("$file.prop.dat");
    $boxplot->output("$file.prop.eps");
    $boxplot->proportional(1);
    $boxplot->plot_it();
}
sub zip {
    my ($arr1,$arr2) = @_;
    return map { [ $arr1->[$_], $arr2->[$_] ] (0..$#arr1);
}
