use strict;
use List::Util qw(shuffle);
my %hash;
my $slash = '\\';
my @sizes = qw(
	tiny
	scriptsize
	footnotesize
	small
	normalsize
	large
	Large
	LARGE
	huge
	Huge
);
my $nsizes = @sizes;
while(<>) {
    chomp;
    $hash{$_}++;
}

my @keys = keys %hash;
my @keys = sort { $hash{$a} <=> $hash{$b} } @keys;
my $max = $hash{$keys[$#keys]};
@keys = reverse @keys;
print <<EOF;
${slash}documentclass[times]{article}
${slash}usepackage{fullpage}
${slash}pagestyle{empty}
${slash}begin{document}
EOF
print "${slash}noindent ";
foreach (@keys) {
    print "{ ${slash}";
    print $sizes[int(($nsizes - 1) * ($hash{$_} / $max))];
    print " $_ } $/";
}
print <<EOF;
${slash}end{document}
EOF
