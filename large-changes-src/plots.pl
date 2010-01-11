#!/usr/bin/perl
#takes reports as input
use LargeChanges;
use TagMap;
use strict;
use Data::Dumper;
use Boxplot;

mkdir "data";
mkdir "plots";

#project or all
my $tag = shift @ARGV;
my $name = shift @ARGV;
die "No name! " unless $name;
my $grouping = shift @ARGV;
die "No grouping" unless $grouping;
my $proportional = ($tag =~ /prop$/ || $grouping =~ /^proportional/);

my @group_types = TagMap::tag_names();
my %group_types = array_to_hash(@group_types);
my $real_grouping = $grouping;
$real_grouping =~ s/^proportional\-//; #strip that
#warn "$grouping vs $real_grouping";
die "No known grouping: $grouping [@group_types]" unless (exists $group_types{$real_grouping});
my @keys = TagMap::get_tags_for($real_grouping);

sub get_x_axis_label_from_grouping {
    my $grouping = $_[0];
    my $types_of_changes = "Types of Commits";
    my $extended_categories = "Extended Swanson Categories";
    my $large =  "Categories of Large Commits";
    my %h = (
             ${TagMap::DETAIL} => $types_of_changes,
             ${TagMap::STBD} => $types_of_changes,
             ${TagMap::SWANSON} => $extended_categories,
             ${TagMap::LARGE} => $large,
             );
    
    my $ret = $h{$grouping};
    return $ret;
}

my $x_axis_label = get_x_axis_label_from_grouping($real_grouping);

my @projects;
if (@ARGV) {
    @projects = @ARGV;
} else {
    @projects = LargeChanges::get_projects();
    @projects = sort @projects;
}
my %projects = array_to_hash(@group_types);



#build the database

#our projects..

#my @names = map { file_to_name($_) } @ARGV;
#my @files = @ARGV;
my @files = map { build_file_name($grouping,$_) } @projects;
my @names = @projects;
#warn @files;
#warn @names;

my %hash = ();
#my %keys = ();
foreach my $file (@files) {
    my $name = file_to_name($file);
    #warn $name;
    die "No real name for $file!" unless $name;
    open(my $fd,$file);
    while((my $line = <$fd>)) {
        my ($key,$val) = split(/\s*\|\s*/,$line);
        $key = LargeChanges::trim($key);
        $val = LargeChanges::trim($val);
        $hash{$name}->{$key} = $val;
        #warn "$name -> $key -> $val";
        #$keys{$key}++;
    }
}

#print Dumper(\%hash);

#build the xtics table
#we map an index to the column name

#my @keys = sort keys %keys;
my @xtics;
my $with_type = "with linespoints"; #lines";
my $xtic_offset = 0.0;

#warn @keys;
#key to index
#my %key_hash = ();
{
    my $cnt = 0;
    @xtics = map { my $c = $cnt++;
                   #$key_hash{$_} = $c;
                   "\"$_\" ".($c + $xtic_offset) } @keys;
}
my @xtic_labels = @keys;


my $xtics = join(",", @xtics);
my @dat_files = ();
for my $n (@names) {
    #warn $n;
    my $fname = file_name_filter("data/${name}-${n}-${grouping}.dat");
    #warn $fname;
    open(my $fd,'>', $fname) or die "$fname";
    my $c = 0;
    foreach my $key (@keys) {
        my $a = $hash{$n}->{$key}; 
        #warn "$n -> $key: [$a]";
        $a = ($a)?$a:0;
        #warn "$n -> $key : $c $a";
        print $fd join("\t",($c,$a)).$/;  
        $c++;
    }
    close($fd);
    push @dat_files, [ $n , $fname ];
}
my $big_plot_name = file_name_filter("plots/${tag}-${grouping}-distribution.plot");
my $big_plot_name_eps = file_name_filter("plots/${tag}-${grouping}-distribution.eps");
open(my $fd,'>',$big_plot_name) or die "distribution plot";
#magic number of labels
my $rotate = "rotate";# (@xtics > 6)?"rotate":"";
my $count_name = ($proportional)?"Proportion of Commits":"Count";
my $tag_name = TagMap::title_of($name) || $name;
#set terminal postscript eps enhanced color "NimbusSanL-Regu" fontfile "/usr/share/texmf-tetex/fonts/type1/urw/helvetic/uhvr8a.pfb"
print $fd <<EOM;
set key below
set title "Distibution of ${tag_name}"
set xlabel "${x_axis_label}"
set ylabel "${count_name}"
#set terminal postscript eps color
set terminal postscript eps enhanced color
set output "${big_plot_name_eps}"
set xtics ${rotate}  ( $xtics )
plot \\
EOM


my @name_map = map {
    my ($n,$fname) = @$_;
    my $proj_name = TagMap::get_project_name($n);
    [$proj_name,$fname]
    } @dat_files;
my @lines = map {
    my ($n,$fname) = @$_;
    my $proj_name = TagMap::get_project_name($n);

    #"\"${fname}\" title \"$n\"  with boxes fs solid"
    "\"${fname}\" title \"${proj_name}\" ${with_type}"
    } @dat_files;

print $fd (join (",\\$/",@lines)).$/;

close($fd);

#now run gnuplot
system("gnuplot",$big_plot_name);

{
    #now make a boxplot!
    my $big_boxplot_name = file_name_filter("plots/${tag}-${grouping}-distribution-boxplot.plot");
    my $big_boxplot_name_eps = file_name_filter("plots/${tag}-${grouping}-distribution-boxplot.eps");
    my $big_boxplot_name_data = file_name_filter("data/${tag}-${grouping}-distribution-boxplot.dat");


    my $big_boxplot_name_prop = file_name_filter("plots/${tag}-${grouping}-distribution-boxplot-prop.plot");
    my $big_boxplot_name_eps_prop = file_name_filter("plots/${tag}-${grouping}-distribution-boxplot-prop.eps");
    my $big_boxplot_name_data_prop = file_name_filter("data/${tag}-${grouping}-distribution-boxplot-prop.dat");


    my $boxplot = Boxplot->new();
    $boxplot->column_labels(@xtic_labels);
    $boxplot->keys_below_plot();
    $boxplot->set_filled_style() if (@name_map > 1);
    $boxplot->plot_file_output($big_boxplot_name);
    $boxplot->data_file_output($big_boxplot_name_data);
    $boxplot->output($big_boxplot_name_eps);
    $boxplot->xlabel($x_axis_label);
    $boxplot->ylabel($count_name);
    $boxplot->title("Distibution of ${tag_name}");
    $boxplot->set_eps_terminal();
    $boxplot->add_data_files(@name_map);

    $boxplot->plot_it();

    $boxplot->plot_file_output($big_boxplot_name_prop);
    $boxplot->data_file_output($big_boxplot_name_data_prop);
    $boxplot->output($big_boxplot_name_eps_prop);
    $boxplot->ylabel("Proportion of Commits");
    $boxplot->title("Proportional Distibution of ${tag_name}");
    $boxplot->proportional(1);
    $boxplot->plot_it();


}






#now make a plot per each project

for my $d (@dat_files) {
    my ($n,$dat_name) = @$d;
    my $proj_name = TagMap::get_project_name($n);
    my $plot_name = file_name_filter("plots/${tag}-${n}-${grouping}-distribution.plot");
    my $eps_plot_name = file_name_filter("plots/${tag}-${n}-${grouping}-distribution.eps");
    #warn $plot_name;
    open(my $fd,'>',$plot_name) or die "distribution plot: $plot_name";
    my $tag_name = TagMap::title_of($n) || $n;

    print $fd <<EOM;
set title "Distibution of ${tag_name}"
set xlabel "${x_axis_label}"
set ylabel "${count_name}"
set terminal postscript eps color
set output "${eps_plot_name}"
set xtics ${rotate}  ( $xtics )
plot \\
EOM
    print $fd "\"${dat_name}\" title \"${proj_name}\" ${with_type}$/";
    close($fd);
    #now run gnuplot
    system("gnuplot",$plot_name);
}


sub array_to_hash {
    my %hash  = ();
    for (@_) {
        $hash{$_}++;
    }
    return %hash;
}
sub file_to_name { 
    my $t = $_[0]; 
    $t =~ s/^.*reports\///; 
    $t =~ s/(\-proportional)?\-([a-zA-Z]+)\-report(\-sorted)?.txt$//; 
    return $t; 
}
sub build_file_name { 
    my ($grouping,$project) = @_;
    my $ret = "reports/${project}-${grouping}-report.txt";
    #warn $ret;
    return $ret;
}
sub file_name_filter {
    my $a = shift;
    $a =~ s/\s/-/g;
    return lc($a);
}
