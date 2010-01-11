use strict;
use Boxplot;
use TagMap;

# just getting some files;
my @files = ();
while (<data/extended-swanson-maintenance-classes-*-swanson.dat>) {
    push @files,$_ unless /proportional/ || /everything/;
}

my @file_map = map {
    my $file = $_;
    my ($name) = ($file =~ 
                  /extended-swanson-maintenance-classes-(.*)-swanson.dat/);
    warn $name;
    warn $file;
    [$name,$file]
    } @files;
my $boxplot = Boxplot->new();

#set column names! 0 to n
$boxplot->column_labels(TagMap::swanson_tags());
$boxplot->preamble("set key below");
$boxplot->plot_file_output("./boxplot-test.plot");
$boxplot->data_file_output("./boxplot-test.dat");
$boxplot->output("./boxplot-test.eps");
$boxplot->set_eps_terminal();
$boxplot->add_data_files(@file_map);

$boxplot->plot_it();

$boxplot->plot_file_output("./boxplot-test-prop.plot");
$boxplot->data_file_output("./boxplot-test-prop.dat");
$boxplot->output("./boxplot-test-prop.eps");
$boxplot->proportional(1);
$boxplot->plot_it();

