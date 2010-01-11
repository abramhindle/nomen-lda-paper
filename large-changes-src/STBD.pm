package STBD;
my @buildres = map { qr/^\Q$_\E$/ } ( "Makefile" , "makefile", "build.xml" ,
   "Makefile.global", "Makefile.inc" , "configure" , "configure.in" ,
   "aclocal.m4" ,"config.guess" ,"config.sub" ,"config.h"
   ,"install-sh" ,"bootstrap.sh" ,"configure.ac" ,"config.status"
   ,"config.sub" ,"Makefile.am","Makefile.in" );
my @testres = ( qr/^.*test.*$/ , qr/^.*\\.t$/ );
my @srcres = map { qr/^.*\Q$_\E$/i } (
  ".c",
  ".cc",
  ".sh",
  ".cpp",
  ".C",
  ".CPP",
  ".C++",
  ".c++",
  ".java",
  ".pl",
  ".rb",
  ".php",
  ".pm",
  ".py",
  ".sql",
);


my @docres = (  qr/.*doxygen$/,
                             qr/\.tex$/,
                             qr/\.txt$/,
                             qr/^INSTALL$/,
                             qr/^README.*$/,
                             qr/^FILES$/,
			     qr/^TODO$/,
			     qr/^AUTHORS$/,
			  );

sub is_build {
    my ($file) = @_;
    foreach my $re (@buildres) {
        if ($file =~ /$re/i) {
            return 1;
        }
    }
    return 0;
}
sub is_src {
    my ($file) = @_;
    foreach my $re (@srcres) {
        if ($file =~ /$re/i) {
            return 1;
        }
    }
    return 0;
}
sub is_test {
    my ($file) = @_;
    foreach my $re (@testres) {
        if ($file =~ /$re/i) {
            return 1;
        }
    }
    return 0;
}
sub is_doc {
    my ($file) = @_;
    foreach my $re (@docres) {
        if ($file =~ /$re/i) {
            return 1;
        }
    }
    return 0;
}

sub file_type {
    my ($file) = @_;
    if ( is_src( $file ) ) {
        return "source";
    } elsif ( is_test( $file )) {
        return "test";
    } elsif ( is_build( $file )) {
        return "build";
    } elsif ( is_doc( $file )) {
        return "documentation";
    } else {
        return "other";
    }
}

sub test {
    my ($o,$d,$b,$s,$t) = qw(other documentation build source test);
    my %test = (  "what" => $o,
       "Makefile" => $b,
       "test" => $t,
       "doxygen" => $d,
       "what.php" => $s,
    );
    while (my ($test,$res) = each %test) {
        my $eres = file_type($test);
        die "$test failed for [$res] [$eres]" unless ($eres eq $res);
    }
}

1;
