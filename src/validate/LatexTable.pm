package LatexTable;
use strict;

sub layout {
    my $obj = shift;
    my $colnames = $obj->{colnames};
    my $rownames = $obj->{rownames};
    my $cols = scalar(@$colnames);
    my $head = join(" & ",(" ",@$colnames))." \\\\$/";
    my $form = "l|".("r"x$cols);
    my @o = ("\\begin{tabular}{$form}$/", $head, "\\hline \\\\$/");
    my $rows = $obj->{rows};
    my $nrows = scalar(@$rows);
    for my $i (0..($nrows-1)) {
        warn $i;
        my @colnames = @$colnames;
        my $rowname = $rownames->[$i];
        my @rows = @{$rows->[$i]};
        my @format = ();
        for my $i (0..($cols-1)) {
            my $colname =  $colnames->[$i];
            push @format, our_format($obj, $rowname, $colname,  $rows[$i]);
        }
        push @o, join(" & ", ($rowname, @format))." \\\\$/";
    }
    push @o, "\\end{tabular}$/";
    return join($/,@o);
}

sub create_table {
    my @args = @_;
    my %h;
    if (scalar(@args) == 0 || scalar(@args) % 2 == 0) {
        %h = @args;
    } else {
        my $c = shift;
        %h = @args;
    }
    my $rownames = $h{rownames} || [];
    my $s = {
            latex_table           => 1,
            rownames              => $rownames,
            colnames              => ($h{colnames} || []),
            rows                  => ($h{rows} || []),
            default_number_format => ($h{default_number_format} || '%0.2f'),
            formats               => ($h{formats} || {}),
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
        my $j = 0;
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
    # transpose these
    my $colnames = $obj->{rownames};
    my $rownames = $obj->{colnames};
    
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
    my $format = undef;
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
        return $val;
    }
}

sub rows {
    my ($obj,$rows) = @_;
    if ($rows) {
        $obj->{rows} = $rows;
    }
    return $obj->{rows};
}

sub set_value {
    die "Doesn't work";
    my ($obj, $col_name, $row_name, $value) = @_;
    my $r = 0;
    my $c = 0;
    foreach my $col (@{$obj->{colnames}}) {
        warn "$col $col_name";
        last if $col_name eq $col;
        $r++;
    }
    foreach my $row (@{$obj->{rownames}}) {
        last if $row_name eq $row;
        $c++;
    }
    warn "$r $c";
    $obj->{rows}->[$r]->[$c] = $value;
}
sub is_num {
    my ($a) = @_;
    if ($a =~ /^[\+\-]?\d+$/) { return 1 }
    elsif ($a =~ /^[\+\-]?\d+\.?\d*$/) { return 1 }
    else { return 0 }
}
1;
