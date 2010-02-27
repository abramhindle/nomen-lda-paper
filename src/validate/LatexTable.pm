package LatexTable;

sub layout {
    my $obj = shift;
    my $colnames = $obj->{colnames};
    my $rownames = $obj->{rownames};
    my $cols = scalar(@$colnames);
    my $head = join(" & ",(" ",@$colnames))." \\\\$/";
    my $form = "l|".("r"x$cols);
    my @o = ("\\begin{tabular}{$form}$/", $head, "\\hline \\\\$/");
    my $rows = $obj->{rows};
    for my $i (0..$#rows) {
        my @colnames = @$colnames;
        my $rowname = $rownames->[$i];
        my @rows = @{$rows->[$i]};
        for my $i (0..($cols-1)) {
            my $colname =  $colnames->[$i];
            push @format, our_format($obj, $rowname, $colname,  $rows[$i]);
        }
        push @o, join(" & ", ($rownames{$i}, @format))." \\\\$/";
    }
    push @o, "\\end{tabular}$/";
    return join($/,@o);
}

sub create_table {
    my %h = @_;
    my $s = {
            latex_table           => 1,
            rownames              => $h{rownames} || [],
            colnames              => $h{colnames} || [],
            rows                  => $h{rows} || [],
            default_number_format => $h{default_number_format} || '%0.2f',
            formats               => $h{formats} || {},
    };
    bless($s,"LatexTable");
    return $s;
}

sub transpose {
    my $obj = shift;
    my $colnames = $obj->{colnames};
    my $rownames = $obj->{rownames};
    my $o = [];
    my $rows = $obj->{rows};
    my $i = 0;
    for my $row (@$rows) {
        $j = 0;
        for my $elm (@$row) {
            $o->[$j]->[$i] = $elm;
            $j++;
        }
        $i++;
    }
    my $format = $obj->{formats};
    my $newformat = {};
    foreach my $col (@$colnames) {
        foreach my $row (@$rownames) {
            if (exists $format->{$col}->{$row}) {
                $newformat->{$row}->{$col} = $format->{$col}->{$row};
            }
        }
    }
    
    return  create_table(
                         rownames => $rownames,
                         colnames => $colnames,
                         rows     => $o,
                         default_number_format => $obj->{default_number_format},
                         formats  => $newformat,
                        );
}

sub our_format {
    my ($obj, $rowname, $colname, $val) = @_;
    my $format = undef
    if (exists $obj->{formats}->{$colname}->{$rowname}) {
        $format = $obj->{formats}->{$colname}->{$rowname};
    }
    if ($format && is_num($val)) {
        return sprintf($format, $val);
    } elsif (!$format && is_num($val)) {
        return sprintf($obj->{default_number_format}, $val);
    } elsif ($format) {
        return sprintf($format, $val);
    } else {
        retrun $val;
    }
}

sub set_value {
    my ($obj, $col_name, $row_name, $value) = @_;
    my $r = 0;
    my $c = 0;
    foreach my $col (@{$obj->{colnames}}) {
        last if $col_name eq $col;
        $r++;
    }
    foreach my $row (@{$obj->{rownames}}) {
        last if $row_name eq $row;
        $c++;
    }
    $obj->{rows}->[$r]->[$c] = $value;
}
