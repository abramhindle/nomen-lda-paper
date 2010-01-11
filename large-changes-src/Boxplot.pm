package Boxplot;
use strict;

my $default_data_file = "/tmp/default_data_file";

sub new {
    my $self = {};
    return bless($self,"Boxplot");
}
sub from_hash {
    my $self = shift;
    return bless($self,"Boxplot");
}

sub proportional {
    my $self = shift;
    if (@_) {
        $self->{proportional} = $_[0];
    }
    return $self->{proportional} || 0;
}

# Base 0 to whatever
sub column_labels {
    my $self = shift;
    
    my @a = @_;
    if (@a) {
        $self->{column_labels} = [@a];
    }
    return @{$self->{column_labels}};
}

sub count_column_labels {
    my $self = shift;
    return scalar ($self->column_labels);
}

sub preamble {
    my $self = shift;
    
    if (@_) {
        $self->{preamble} = $_[0];
    }
    return $self->{preamble};
}


sub title {
    my $self = shift;
    
    if (@_) {
        $self->{title} = $_[0];
    }
    return $self->{title};
}
sub xlabel {
    my $self = shift;

    if (@_) {
        $self->{xlabel} = $_[0];
    }
    return $self->{xlabel};
}
sub ylabel {
    my $self = shift;

    if (@_) {
        $self->{ylabel} = $_[0];
    }
    return $self->{ylabel};
}
sub set_eps_terminal {
    my $self = shift;
    #$self->terminal("postscript eps enhanced color \"NimbusSanL-Regu\" fontfile \"/usr/share/texmf-tetex/fonts/type1/urw/helvetic/uhvr8a.pfb\"");
    $self->terminal("postscript eps enhanced color");
}
sub keys_below_plot {
    my $self = shift;
    my $str = "set key below";
    if ($self->preamble) {        
        $self->preamble($self->preamble()."$/".$str);
    } else {
        $self->preamble($str);
    }
}

sub terminal {
    my $self = shift;

    #set terminal postscript eps enhanced color "NimbusSanL-Regu" fontfile "/usr/share/texmf-tetex/fonts/type1/urw/helvetic/uhvr8a.pfb"
    if (@_) {
        $self->{terminal} = $_[0];
    }
    return $self->{terminal};    
}
sub output {
   my $self = shift;
   if (@_) {
        $self->{output} = $_[0];
   }
   return $self->{output};    
}

sub plot_file_output {
    my $self = shift;
    if (@_) {
        $self->{plot_file_output} = $_[0];
    }
    return $self->{plot_file_output};    
}

sub data_file_output {
    my $self = shift;
    if (@_) {
        $self->{data_file_output} = $_[0];
    }
    return ($self->{data_file_output} || $default_data_file);    
}

# list of $title,$file,$title,$file
sub add_data_files {
    my $self = shift;
    while (@_) {
        my $title = shift;
        #if it is an array ref just add it
        if (ref($title) eq 'ARRAY') {
            $self->add_data_file(@$title);
        } else {
            my $file = shift;
            $self->add_data_file($title,$file);
        }
    }
}

sub add_data_file {
    my $self = shift;
    my $title = shift;
    my $datafile = shift;
    die "No datafile set in add_data_file!" unless defined $datafile;
    $self->{data_files} = [] unless (defined($self->{data_files}));
    my $n = scalar(@{$self->{data_files}});
    push @{$self->{data_files}}, [$title,$datafile];

    $self->{title_to_data_file}->{$title} = $datafile;
    $self->{data_file_to_file}->{$title} = $datafile;
    $self->{column_number_to_file}->{$n} = $datafile;
    $self->{column_number_to_title}->{$n} = $title;
    $self->{title_to_number}->{$title} = $n;
    $self->{file_to_number}->{$datafile} = $n;
}
sub data_files {
    my $self = shift;
    return (map { $_->[1] } @{$self->{data_files}});
}
sub data_file_titles {
    my $self = shift;
    return (map { $_->[0] } @{$self->{data_files}});
}

sub count_data_files {
    my $self = shift;
    return scalar @{$self->{data_files}};
}

sub generate_data_file {
    my $self = shift;
    my $data_file = $self->data_file_output;
    my $n = $self->count_data_files;
    my $rows = $self->count_column_labels;
    my @file_arrays = map {
        my $fd = open_or_die($_);
        my @a = ();
        while(my $line = <$fd>) {
            chomp($line);
            my ($i,$v) = split(/\s+/,$line);
            $a[$i] = $v;
        }
        close($fd);
        \@a;
        } ($self->data_files);
    my $fd = open_for_write($data_file);
    foreach my $row (0..($rows-1)) {
        my @res = map { $a = $_->[$row]; (defined($a))?$a:0 } @file_arrays;
        my $str = join("\t",$row,@res);
        print $fd ($str.$/);        
    }
    close($fd);
    return $data_file;
}
sub open_or_die {
    my $file = $_[0];
    my $fd;
    open($fd,$file) or die "Could not open $file [for reading]"; 
    return $fd;   
}
sub open_for_write {
    my $file = $_[0];
    my $fd;
    open($fd,">",$file) or die "Could not open $file [for writing]"; 
    return $fd;   
}

sub xtics {
    my $self = shift;
#  ( "Build" 0,"Source Code" 1,"Test" 2,"Documentation" 3,"Data" 4 )
    my @cols = $self->column_labels;
    my $n = @cols;

    my @l = map {
        my $i = $_;
        "\"$cols[$i]\" $i";
    } (0..($n-1));

    return "( " . join(", ",@l) . " )";
}

sub plot_it {
    my $self = shift;
    $self->generate_data_file;
    my $plot_file = $self->generate_plot_file;
    system("gnuplot",$plot_file);
}
sub gen_sum {
    my ($start,$end) = @_;
    my @cols = map { "\$".($_) } ($start..$end);
    return "(".join("+",@cols).")";
}
sub fill_style {
    my $self = shift;
    if (@_) {
        $self->{fill_style} = $_[0];
    }
    return ($self->{fill_style} || "pattern");
}
sub set_filled_style {
    my $self = shift;
    $self->fill_style("solid");
}
sub generate_plot_file {
    my $self = shift;
    my $plot_file = $self->plot_file_output;
    my $data_file = $self->data_file_output;
    my $n = $self->count_data_files;
    my $cols = $self->count_column_labels;
    my @column_labels = $self->column_labels;
    my @data_file_titles = $self->data_file_titles();
    my $fd = open_for_write($plot_file);
    my $pl = sub { print $fd (@_,$/); };
    my $pldef = sub { if (defined($_[0])) { print $fd (@_,$/) } };
    my $pl2def = sub { if (defined(shift @_)) { print $fd (@_,$/) } };
    
    #set key below
    &$pldef($self->preamble);
    my $title = $self->title;
    my $xlabel = $self->xlabel;
    my $ylabel = $self->ylabel;
    my $terminal = $self->terminal;
    my $output = $self->output;
    my $xtics = $self->xtics;
    my $fill_style = $self->fill_style;
    &$pl("set style fill ${fill_style}");
#    &$pl("set style fill pattern");
#    &$pl("set style fill solid");
    &$pl2def($title,"set title \"$title\"");
    &$pl2def($xlabel,"set xlabel \"$xlabel\"");
    &$pl2def($ylabel,"set ylabel \"$ylabel\"");
    &$pl2def($terminal,"set terminal $terminal");
    &$pl2def($xtics,"set xtics rotate $xtics");
    &$pl2def($output,"set output \"$output\"");
    #( "Build" 0,"Source Code" 1,"Test" 2,"Documentation" 3,"Data" 4 )
    my $maxx = $cols - 0.5;
    &$pl("plot [-0.5:$maxx] [0:] \\");
    my $maxsum = gen_sum(2,$n+1);
    my @plots = map { 
        my $k = $_;
        my $start = $k + 2;
        
        my $sum = gen_sum($start,($n+1)); #map { "\$".($_) } ($start..($n+1));        
        my $sum = ($self->proportional())?"1:($sum/$maxsum)":"1:$sum";
        my $title = $data_file_titles[$k];
        "\"${data_file}\" using ${sum} title \"${title}\" with boxes";
    } (0..($n-1));
    &$pl(join(",\\$/",@plots));
    close($fd);
    return $plot_file;
    #    plot [-0.5:$maxx] [0:] "test4.dat" using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10) w boxes, "test4.dat" using 1:($3+$4+$5+$6+$7+$8+$9+$10) w boxes, "test4.dat" using 1:($4+$5+$6+$7+$8+$9+$10) w boxes, "test4.dat" using 1:($5+$6+$7+$8+$9+$10) w boxes, "test4.dat" using 1:($6+$7+$8+$9+$10) w boxes, "test4.dat" using 1:($7+$8+$9+$10) w boxes, "test4.dat" using 1:($8+$9+$10) w boxes, "test4.dat" using 1:($9+$10) w boxes,  "test4.dat" using 1:($10) w boxes
}

1;
