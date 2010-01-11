use ARFF;
use strict;

#my @ARFF = map { ARFF->new( filename => $_ ) }  @ARGV;

my $ARFF = ARFF::join_arff_files( @ARGV );

$ARFF->writeout("-");

__DATA__

 LOL WE JUST IGNORED THIS AHAHAHA
 Old implementation
 THIS DOES NOT RUN

my @states = qw(REALATION ATTRIBUTE DATA);

my %headers = ();

foreach my $file (@ARGV) {
    my %header = read_header($file);
    $headers{$file} = \%header;
}

#now for the joining!
#first we join headers!

my %superheader = (
                   type => {},
                   attributes => [],
                  );
foreach my $file (@ARGV) {
    my $header = $headers{$file};
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

my %type = %{$superheader{type}};


#print the header of the new ARFF file
my @superattrs = @{$superheader{attributes}};
print "\@RELATION joinedfiles$/";
foreach my $attr (@superattrs) {
    print "\@ATTRIBUTE $attr ".$superheader{type}->{$attr}.$/;
}
print "\@DATA$/";

#XXX: Idea add a new class of "file origin"

# now the headers are joined,
# we can read each file and then print big vectors of counts etc.

foreach my $file (@ARGV) {
    my $header = $headers{$file};
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

    my @attrs = @{$header->{attributes}};
    my %indices = %{$header->{indices}};
    #my %type = %{$header->{type}};

    #process each line
    #remap the indices, use the indices from
    #the superattribute list
    while(my $line = <$fd>) {
        chomp($line);
        my @elms = split(/\,/, $line);
        my @out = map {
            my $attr = $_;
            my $o;
            if (exists $indices{$attr}) {
                $o = $elms[$indices{$attr}];
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
        print join(",",@out),$/;
    }
    close $fd;
}


sub read_header {
    my ($filename) = @_;
    my %hash = (
                attributes => [],
                indices => {},
                type => {},
               );
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
