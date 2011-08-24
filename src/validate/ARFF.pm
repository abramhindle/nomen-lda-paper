package ARFF;
#This package is meant to read, parse and manipulate ARFF files
use strict;
use Data::Dumper;
use Carp qw(croak confess);

sub new {
    my $type = shift;
    my %hash = @_;
    my $self = bless({},$type);
    my %dflheader = dfl_header();
    $self->data( $hash{data} || [] );
    $self->header( $hash{header} || \%dflheader );
    $self->relation( $hash{relation} || "joinedfiles");
    if ($hash{filename}) {
        my $file = $hash{filename};
        my $header = parse_arff_header($file);
        my $data = parse_arff_data($header,$file);
        $self->header($header);
        $self->data($data);
        die "NO DATA?" unless $self->{data};
        die "NO HEADER?" unless $self->{header};
    }
    return $self;
}

sub header {
    my ($self, $header) = @_;
    if (defined $header) {
        $self->{header} = $header;
    }
    return $self->{header};
}
sub copy_header {
    my ( $self ) = @_;
    my $header = $self->header();
    my $new_header = {};
    $new_header->{attributes} = [ @{$header->{attributes}} ];
    while (my ($key, $val) = each %{$header->{indices}}) {
        $new_header->{indices}->{$key} = $val;
    }
    while (my ($key, $val) = each %{$header->{type}}) {
        $new_header->{type}->{$key} = $val;
    }
    return $new_header;
}

sub relation {
    my ($self, $relation) = @_;
    if (defined $relation) {
        $self->{relation} = $relation;
    }
    return $self->{relation};
}

sub data {
    my ($self, $data) = @_;
    if (defined $data) {
        $self->{data} = $data;
    }
    return $self->{data};
}

sub writeout {
    my ($self,$filename) = @_;
    my $fd = write_open_or_stdout( $filename || "-" );
    my $header = $self->header();
    die "NO ATTRIBUTES?" unless $header->{attributes};
    $self->print_header( $fd, $self->header() );
    print_data( $fd, $self->data() );
    close $fd;
}

sub writeout_csv {
    my ($self,$filename) = @_;
    my $fd = write_open_or_stdout( $filename || "-" );
    my $header = $self->header();
    die "NO ATTRIBUTES?" unless $header->{attributes};
    $self->print_csv_header( $fd, $self->header() );
    print_data( $fd, $self->data() );
    close $fd;
}

sub _gen_type {
    my ($type, @classes) = @_;
    if ($type eq "REAL") {
        return "REAL";
    } elsif (uc($type) eq "INTEGER") {
        return "INTEGER";
    } elsif (uc($type) eq "NUMERIC") {
        return "NUMERIC";
    } elsif ($type eq "CLASS") {
        return "{" . join(",",@classes) . "}";
    } else {
        die "i didn't understand type $type";
    }
}

sub change_type {
    my ($self,$typename,$typetype,@classes) = @_;
    warn Dumper($self->header()->{type});
    $self->header()->{type}->{$typename} = _gen_type($typetype, @classes);
    warn Dumper($self->header()->{type}); 
}



### SUBS NOT METHODS ###

#joins the headers in memory.. could be slow..
#makes an ARFF object

sub join_arffs {
    my @arffs = @_;
    my @headers = map { $_->header() } @arffs;
    my @datas = map { $_->data() } @arffs;

    my $superheader = join_headers(@headers);
    
    #warn Dumper($superheader);
    
    my $superdata = join_data($superheader,\@headers,\@datas);

    return ARFF->new(data=>$superdata, header=>$superheader);

}

sub join_arff_files {
    my (@files) = @_;

    my @ARFF = map { ARFF->new( filename => $_ ) }  @ARGV;
    return join_arffs(@ARFF);
}



sub join_data {
    my ($superheader,$headers,$data) = @_;
    my %superheader = %{$superheader};
    my %type = %{$superheader{type}};
    my @superattrs = @{$superheader{attributes}};
    my @dataout = ();
    my $n = scalar @$headers;
    for my $i  (0..($n-1)) {
        my $header = $headers->[$i];
        my $fdata = $data->[$i];
        my @attrs = @{$header->{attributes}};
        my %indices = %{$header->{indices}};

        #process each line
        #remap the indices, use the indices from
        #the superattribute list
        foreach my $elms (@$fdata) {
            my @out = map {
                my $attr = $_;
                my $o;
                if (exists $indices{$attr}) {
                    $o = $elms->[$indices{$attr}];
                } else {
                    #default value for a missing attribute
                    if ($type{$attr} eq "REAL") {
                        $o = 0;
                    } else {
                        die "Can't choose a default for a NON-REAL type! $attr - $type{$attr}" ;
                    }
                }
                $o
            } @superattrs;
            push @dataout, \@out;
        }
    }    
    return \@dataout;
}


sub parse_arff_header {
    my ($file) = @_;
    my %header = read_header($file);
    return \%header;
}

sub print_header {
    my ($self,$fd, $header) = @_;

    my %superheader = %$header;
    #print the header of the new ARFF file
    confess "Not an arrayref! ".Dumper($header) unless 'ARRAY' eq ref($superheader{attributes});
    my @superattrs = @{$superheader{attributes}};
    
    print $fd "\@RELATION ".$self->relation()."$/";
    foreach my $attr (@superattrs) {
        print $fd "\@ATTRIBUTE $attr ".$superheader{type}->{$attr}.$/;
    }
    print $fd "\@DATA$/";
}
sub print_csv_header {
    my ($self,$fd, $header) = @_;

    my %superheader = %$header;
    #print the header of the new CSV file
    confess "Not an arrayref! ".Dumper($header) unless 'ARRAY' eq ref($superheader{attributes});
    my @superattrs = @{$superheader{attributes}};
    print $fd join(",",@superattrs),$/;
}


sub attributes {
    my ($self,@more) = @_;
    if (@more) {
        die "You can't set attributes this way!";
    }
    return $self->get_attributes();
}

sub get_attributes {
    my ($self) = @_;
    my $header = $self->header();
    my @attributes =  @{$header->{attributes}};
    return @attributes;
}

sub print_data {
    my ( $fd, $data ) = @_;
    die "Not an arrayref" unless ref($data) eq "ARRAY";
    my $cnt = 0;
    foreach my $elm ( @$data ) {
        
        unless (ref($elm) eq "ARRAY") {
            warn "ELM Not an arrayref [$cnt]";
            next;
            open(my $ffd,">","dump");
            print $ffd Dumper($data).$/;
            print $ffd Dumper(\$elm).$/;
            close($ffd);
        }
        my @arr = @$elm;
        print $fd join( "," , @arr ).$/;
        $cnt++;
    }
}

my @states = qw(REALATION ATTRIBUTE DATA);

#do we need this yet?
sub parse_arff {
    my ($filename) = @_;
    return ARFF->new(filename=>$filename);
}

sub read_header {
    my ($filename) = @_;
    my %hash = dfl_header();
    open(my $fd, $filename) or die "COULD NOT OPEN $filename";
    my $attr = 0;
    while(my $line = <$fd>) {
        chomp($line);
        next if (/^#/);
        if ($line =~ /^\@RELATION\s*(.*)\s*$/) {
            $hash{relation} = $1;
        } elsif ($line =~ /^\@ATTRIBUTE\s+([^\s]+)\s+(.*)\s*$/) {
            my $name = $1;
            my $val = $2;
            push @{$hash{attributes}}, $name;
            $hash{indices}->{$name} = $attr++;
            $hash{type}->{$name} = join_type($hash{type}->{$name}, $val);
        } elsif ($line =~ /^\@DATA/) {
            return %hash;
        } else {
            warn "Didn't read or understand [$line]";
        }
    }
    die "Didn't see DATA";
}

sub join_type {
    my ($a,$b) = @_;
    if (!defined $a) {
        return $b;
    }
    if (!defined $b) {
        return $a;
    }
    if ($a eq $b) {
        return $b;
    }
    die "$a $b -- I dunno how to join these!" unless ($a =~ /^\{/ && $b =~ /^{/);
    $a =~ s/[{}]//g;
    $b =~ s/[{}]//g;
    my @a = split(/,/,$a);
    my @b = split(/,/,$b);
    my %uniq = map { $_ => 1 } (@a,@b);
    my @joined = sort keys %uniq;
    return "{" . join(",",@joined)  . "}";
}

sub join_headers {
    my @headers = @_;
    my %superheader = (
                   type => {},
                   attributes => [],
                  );
    foreach my $header (@headers) {
        foreach my $attribute (@{$header->{attributes}}) {
            push @{$superheader{attributes}}, $attribute unless 
            (exists $superheader{type}->{$attribute});
            $superheader{type}->{$attribute} =
            join_type(
                      $superheader{type}->{$attribute},
                      $header->{type}->{$attribute});
        }
    }
    sort @{$superheader{attributes}};
    my $index = 0;
    foreach my $attr (@{$superheader{attributes}}) {
        $superheader{indices}->{$attr} = $index++;
    }
    return \%superheader;
}


sub parse_arff_data {
    my ($header,$file) = @_;
    
    open(my $fd, $file) or die "$file not accessible!";
    #read past @DATA
    {
        my $line;
        do {
            $line = <$fd>;
            chomp($line);
            $line =~ s/\s*$//;
        } until ($line eq '@DATA');
    }

    my @out = ();
    while(my $line = <$fd>) {
        chomp($line);
        my @elms = split(/\,/, $line);
        push @out, \@elms;
    }
    return \@out;
}

sub write_open_or_stdout {
    my ($filename) = @_;
    if ($filename eq "-" || !defined $filename ) {
        my $fd = \*STDOUT;
        return $fd;
    } else {
        open( my $fd, ">", $filename ) or die "Couldn't open $filename";
        return $fd;
    }
}

sub class_filter {
    my $a = shift;
    $a =~ s/\s/-/g;
    return $a;
}

sub add_row {
    my ($self, @row) = @_;
    push @{$self->data()},[@row];
}

sub add_column {
    my ($self, $name, $type, @classnames) = @_;
    my $header = $self->header();
    die "Bad header! not a hash! $header" unless ref($header) eq 'HASH';
    die "bad header!" unless ref($header->{attributes}) eq 'ARRAY';
    $header->{indices}->{$name} = scalar @{$header->{attributes}};
    push @{$header->{attributes}}, $name;
    $header->{type}->{$name} = _gen_type($type, @classnames);
    my $data = $self->data();
    #try not to add columns after data exists..
    foreach (@$data) {
        push @$_, undef;
    }
}

sub dfl_header {
    return 
    (
     attributes => [],
     indices => {},
     type => {},
    );
}

# mutate_class will map a class and mutate the data
# $classname : the attribute with the type class
# $variants : array ref of new class values
# $classmapfun : a mapper function : class -> class
#                used to map old class ot new class
sub mutate_class {
    my ($self, $classname, $variants, $classmapfun) = @_;
    $self->change_type( $classname, 'CLASS', (map {ARFF::class_filter($_)} @$variants) );
    my $classindex = $self->header()->{indices}->{$classname};
    my $data = $self->data();
    foreach my $elm (@$data) {
        my $e = ARFF::class_filter( &$classmapfun( $elm->[$classindex] ) );
        unless (defined $e) {
            warn "[$e] $elm->[0] NOT DEFINED??? ";
            next;
        }
        $elm->[$classindex] = $e;
    }
    return 1;
}

# same but produces a new class

sub map_class {
    my ($self, $classname, $variants, $classmapfun) = @_;
    #$arff->change_type( $classname, 'CLASS', (map {ARFF::class_filter($_)} @$variants) );
    my $classindex = $self->header()->{indices}->{$classname};
    my $data = $self->data();
    my @out = ();
    foreach my $elm (@$data) {
        my $nelm = [ @$elm ];  # copy it
        my $e = ARFF::class_filter( &$classmapfun( $nelm->[$classindex] ) );
        unless (defined $e) {
            warn "[$e] $elm->[0] NOT DEFINED??? Removing row";
            next;
        }
        $nelm->[$classindex] = $e;
        push @out, $nelm;
    }
    my $newarff = ARFF->new( header => $self->copy_header, data => \@out );
    $newarff->change_type( $classname, 'CLASS', (map {ARFF::class_filter($_)} @$variants) );
    return $newarff;
}

sub copy_data {
    my ($self) = @_;
    my $data = $self->data();
    my @out = ();
    foreach my $elm (@$data) {
        my $nelm = [ @$elm ];  # copy it
        push @out, $nelm;
    }
    return \@out;
}

sub copy {
    my ($self) = @_;
    my $newarff = ARFF->new( header => $self->copy_header , data => $self->copy_data );
    return $newarff;
}

# THIS MUTATES THE ARFF
sub drop_columns {
    my ($self,@columns) = @_;
    my %columns = map { $_ => 1 } @columns;
    my $header = $self->header;
    my @attributes = $self->attributes();
    my $nattr = scalar @attributes;
    my %indices = map { $header->{indices}->{$_} => 1 } @columns;
    my @cindices = grep { !exists $indices{$_} } (0..($nattr-1));
    my @new_attributes = map { $attributes[$_] } @cindices;
    my $data = $self->data();
    my @o = ();
    foreach my $row (@$data) {
        my @row = @$row;
        my @newrow = map { $row[$_] } @cindices;
        push @o, \@newrow;
    }
    #now update data
    $self->data(\@o);

    # now modify the header
    # my @new_attributes = grep { exists $columns{$_} } @columns;
    # remove the type
    $header->{attributes} = \@new_attributes;
    foreach my $c (@columns) {
        delete $header->{type}->{$c};
    }
    {
        delete($header->{indices});
        $header->{indices} = {};
        # assign new indicies!
        my $i = 0;
        $header->{indices}->{$_} = $i++ for @new_attributes;
    }
    #header should be updated now
    return $self;
}
# THIS MUTATES THE ARFF
sub drop_column {
    my ($self,@rest) = @_;
    $self->drop_columns(@rest);
}

1;
