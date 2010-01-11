#!/usr/bin/perl
use TagMap;
use strict;

foreach my $tag (TagMap::tag_names()) {
    my $tag_name = TagMap::tag_map($tag);
    sys("perl -x plots.pl project '${tag_name}' ${tag}");
    sys("perl -x plots.pl project    '${tag_name}' proportional-${tag}");
    my $tn = TagMap::title_of($tag_name);
    sys("perl -x plots.pl all '${tn} of all projects' ${tag} Everything");
    sys("perl -x plots.pl prop '${tn} of all projects' ${tag} Proportional");
}
sub sys {
    print @_,$/;
    system(@_);
}
