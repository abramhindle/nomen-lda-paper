#!/usr/bin/perl
open(FILE,">","Makefile.images");
print FILE "# make image auto generated$/";
my @ALL =();
for my $file (<output/*.eps>) {
	print FILE "$file.pdf: $file$/";
	print FILE "\tepstopdf --outfile=$file.pdf $file$/";
	print FILE "$file.png: $file$/";
	print FILE "\tconvert $file $file.png$/";
	push @ALL, "$file.pdf";
	push @ALL, "$file.png";
}
print FILE "all: ".join(" ",@ALL).$/;
exec(qw(make -f Makefile.images -j 4 --ignore-errors all));
