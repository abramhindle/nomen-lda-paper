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

    if (!@notstacked && !@stacked) {
        die "Neither Stacked nor not stacked";
    }


    my @column_names = $doc->getElementsByTagName('column_name');
    @column_names or die "No column_names!";
    my @column_names = map { $_->textContent } @column_names;
    my ($plot_name) = $doc->getElementsByTagName('plot_name');
    $plot_name = $plot_name->textContent();
    my @rows;
    { 
        my ($rows) = $doc->getElementsByTagName('rows');
        $rows = $rows->textContent();
        @rows = map { 
            # make an array ref of values per row
            [ split(/[\s\t]+/, $_)  ] 
        } (split(/[\r\n]+/,$rows)); #split by newline
    }

    @rows or die "No rows!";

    my @rownames = $doc->getElementsByTagName('row_name');
    @rownames = map { $_->textContent } @rownames;

    if (@notstacked && !@rownames) {
        @rownames = ( $plot_name );
    }

    warn "Rownames: @rownames";
    warn "Column_names: @column_names";
    

    my @zrows = zip2(\@rownames, \@rows);

    boxplotit( $file , \@column_names, \@zrows );

    my @newrows = transpose(@rows);
    my @newzrows = zip2(\@column_names, \@newrows);
    boxplotit( $file.".transpose" , \@rownames, \@newzrows );
    
    
}

sub transpose {
    my @rows = @_;
    my $nrows = @rows;
    my $ncols = @{$rows[0]};
    map { my $col = $_;
          [
           map {
               my $row = $_;
               $rows[$row]->[$col]
           } (0..($nrows-1))
          ]
      } (0..($ncols-1));
    
}

sub boxplotit {
    my ($file,$column_names,$zrows) = @_;
    my @column_names = @$column_names;
    my @zrows = @$zrows;

    my $boxplot = Boxplot->new();


    #set column names! 0 to n
    $boxplot->column_labels( @column_names  );
    $boxplot->preamble("set key below");
    $boxplot->plot_file_output("$file.plot");
    $boxplot->data_file_output("$file.dat");
    $boxplot->output("$file.eps");
    $boxplot->set_eps_terminal();
    #$boxplot->add_data_files(@file_map);
    $boxplot->add_data_rows(@zrows);
    $boxplot->plot_it();

    $boxplot->plot_file_output("$file.prop.plot");
    $boxplot->data_file_output("$file.prop.dat");
    $boxplot->output("$file.prop.eps");
    $boxplot->proportional(1);
    $boxplot->plot_it();


}
sub zip2 {
    my ($arr1,$arr2) = @_;
    my $len = scalar(@$arr1);
    return map { [ $arr1->[$_], $arr2->[$_] ] } (0..($len-1));
}
