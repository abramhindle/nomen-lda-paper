use List::Util qw(shuffle);
while(<>) {
    chomp;
    $hash{$_}++;
}
my @keys = keys %hash;
my @keys = sort { $hash{$a} <=> $hash{$b} } @keys;
#print join($/,@keys),$/;
#print $hash{$keys[$#keys]};
#print join($/,(map { $hash{$_} } @keys)),$/;
my $max = $hash{$keys[$#keys]};
@keys = reverse @keys;
print "<html><body>$/";
foreach (@keys) {
    print "<font size=\"".int(7 *($hash{$_} / $max))."\">$_</font>$/";
}
#print "<p>";
#foreach (shuffle(@keys)) {
#    print "<font size=\"".int(7 *($hash{$_} / $max))."\">$_</font>$/";
#}
print "</body></html>$/";
