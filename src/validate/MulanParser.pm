package MulanParser;
use strict;
use Data::Dumper;
my @STATES;
my ($NAME,$EXAMPLE,$EXAMPLEDATA,$LABEL,$RANK,$CSV) = @STATES = (100..120);

# mulan_parser: array of text lines -> hashref of learners and keys
# These are keys to expect to be set!
# $hash->{learner-name}->{example-HammingLoss}    = 0.13242240215924425
# $hash->{learner-name}->{example-Accuracy}       = 0.46523391812865506
# $hash->{learner-name}->{example-Precision}      = 0.4924988753936123
# $hash->{learner-name}->{example-Recall}         = 0.4726608187134504
# $hash->{learner-name}->{example-Fmeasure}       = 0.48213920611711664
# $hash->{learner-name}->{example-SubsetAccuracy} = 0.43178137651821863
# $hash->{learner-name}->{label-micro-Precision}  = 0.4900396825396826
# $hash->{learner-name}->{label-micro-Recall}      = 0.14277351214851214
# $hash->{learner-name}->{label-micro-F1}           = 0.21405083655083654
# $hash->{learner-name}->{label-macro-Precision}    = 0.18240740740740738
# $hash->{learner-name}->{label-macro-Recall}       = 0.1006655844155844
# $hash->{learner-name}->{label-micro-F1}           = 0.12209220790103144
# $hash->{learner-name}->{label-micro-AUC}        = 0.6826577833986901
# $hash->{learner-name}->{label-macro-AUC}   = NaN
# $hash->{learner-name}->{rank-One-error}    = 0.7607287449392712
# $hash->{learner-name}->{rank-Coverage}     = 1.1618083670715247
# $hash->{learner-name}->{rank-Ranking Loss} = 0.3193928875980364
# $hash->{learner-name}->{rank-AvgPrecision} = 0.6006514440079371

sub mulan_parser {
    my @lines = @_;
    my $state = $NAME;
    my $name = undef;
    my $micro = 0;
    my $macro = 0;
    my $mm = "";
    my %db = ();
    while(@lines) {
        my ($line) = shift @lines;
        chomp($line);
        if ($line =~ /Loading the data set/) {
            
        } elsif ($state == $NAME) {
            $name = $line;
            $db{$name} = {};
            $state = $EXAMPLE;
        } elsif ($state == $EXAMPLE && $line =~ /====+Example/) {
            $state = $EXAMPLEDATA;
        } elsif ($state == $EXAMPLEDATA && $line =~ /===+Label/) {
            $state = $LABEL;
        } elsif ($state == $EXAMPLEDATA) {
            my ($label, $v) = lsplit($line);
            $db{$name}->{"example-$label"} = trim($v)
        } elsif ($state == $LABEL && $line =~ /MICRO/) {
            $micro = 1;
            $macro = 0;
            $mm = "micro";
        } elsif ($state == $LABEL && $line =~ /MACRO/) {
            $micro = 0;
            $macro = 1;
            $mm = "macro";
        } elsif ($state == $LABEL && $line =~ /===+Rank/) {
            $state = $RANK;
        } elsif ($state == $LABEL) {
            my ($label, $v) = lsplit($line);
            $db{$name}->{"label-$mm-$label"} = trim($v);
        } elsif ($state == $RANK) {
            my ($label, $v) = lsplit($line);
            $db{$name}->{"rank-$label"} = trim($v);
        } elsif ($state == $RANK && !($line =~ /\:/)) {
            $state = $CSV;
        } elsif ($state == $CSV && $line =~ /;/) {
            $state = $NAME;
            my @a = split(/;/,$line);
            unshift @a, $name;
            $db{csv} = \@a;
        }
    }
    return \%db;
}

sub lsplit {
    my $line = shift;
    my @a = split(/\s*\:\s*/,$line);
    return @a;
}

sub trim {
    my $a = shift;
    $a =~ s/^\s*//g;
    $a =~ s/\s*$//g;
    return $a;
}

sub test {
    my @data = <DATA>;
    my $h = mulan_parser(@data);
    foreach my $key (keys %$h) {
        ("NaN" eq $h->{$key}->{"label-macro-AUC"}) or die "[$key] died: ".Dumper($h);
        ($h->{$key}->{"rank-AvgPrecision"} > 0) or die "[$key] AvgPrecision not greater than 0!";
    }
}

1;
__DATA__
Loading the data set
HOMER
Constructing the label hierarchy
[A_functionality, A_usability, MetaLabel 1, A_reliability, A_efficiency, MetaLabel 2, MetaLabel 3, A_maintainability, A_portability]
Creating the hierarchical data set
Constructing the label hierarchy
[A_functionality, A_usability, MetaLabel 1, A_reliability, MetaLabel 2, A_efficiency, MetaLabel 3, A_maintainability, A_portability]
Creating the hierarchical data set
Constructing the label hierarchy
[A_functionality, A_usability, MetaLabel 1, A_reliability, A_efficiency, MetaLabel 2, MetaLabel 3, A_maintainability, A_portability]
Creating the hierarchical data set
Constructing the label hierarchy
[A_functionality, A_usability, MetaLabel 1, A_reliability, MetaLabel 2, A_efficiency, MetaLabel 3, A_maintainability, A_portability]
Creating the hierarchical data set
Constructing the label hierarchy
[A_functionality, A_usability, MetaLabel 1, A_efficiency, MetaLabel 2, A_reliability, MetaLabel 3, A_maintainability, A_portability]
Creating the hierarchical data set
Constructing the label hierarchy
[A_functionality, A_usability, MetaLabel 1, A_reliability, MetaLabel 2, A_efficiency, MetaLabel 3, A_maintainability, A_portability]
Creating the hierarchical data set
Constructing the label hierarchy
[A_functionality, A_usability, MetaLabel 1, A_efficiency, MetaLabel 2, A_reliability, MetaLabel 3, A_maintainability, A_portability]
Creating the hierarchical data set
Constructing the label hierarchy
[A_functionality, A_usability, MetaLabel 1, MetaLabel 2, A_reliability, A_efficiency, MetaLabel 3, A_maintainability, A_portability]
Creating the hierarchical data set
Constructing the label hierarchy
[A_functionality, A_usability, MetaLabel 1, A_reliability, MetaLabel 2, A_efficiency, MetaLabel 3, A_maintainability, A_portability]
Creating the hierarchical data set
Constructing the label hierarchy
[A_functionality, A_usability, MetaLabel 1, A_reliability, MetaLabel 2, A_efficiency, MetaLabel 3, A_maintainability, A_portability]
Creating the hierarchical data set
========Example Based Measures========
HammingLoss    : 0.1367971210076473
Accuracy       : 0.5053812415654522
Precision      : 0.5273976608187135
Recall         : 0.5319725596041386
Fmeasure       : 0.5295243302780946
SubsetAccuracy : 0.4548582995951417
========Label Based Measures========
MICRO
Precision    : 0.4873081769481364
Recall       : 0.26415004290004285
F1           : 0.3373590508968781
MACRO
Precision    : 0.3193915343915344
Recall       : 0.1989565527065527
F1           : 0.23222224573634592
MICRO
AUC          : 0.6210109520700938
MACRO
AUC          : NaN
========Ranking Based Measures========
One-error    : 0.8123481781376517
Coverage     : 1.432456140350877
Ranking Loss : 0.41019090293446697
AvgPrecision : 0.5359258569900733

0.1367971210076473;0.5053812415654522;0.5273976608187135;0.5319725596041386;0.5295243302780946;0.4548582995951417;0.4873081769481364;0.26415004290004285;0.3373590508968781;0.3193915343915344;0.1989565527065527;0.23222224573634592;0.6210109520700938;NaN;0.8123481781376517;1.432456140350877;0.41019090293446697;0.5359258569900733;
BR
========Example Based Measures========
HammingLoss    : 0.18776428250112462
Accuracy       : 0.4897998200629779
Precision      : 0.49685335132703556
Recall         : 0.6100989653621233
Fmeasure       : 0.5472528510845309
SubsetAccuracy : 0.4035087719298246
========Label Based Measures========
MICRO
Precision    : 0.3392958456366339
Recall       : 0.46975142350142346
F1           : 0.38979896287379173
MACRO
Precision    : 0.28996679246679247
Recall       : 0.38437839937839935
F1           : 0.31530202145934416
MICRO
AUC          : 0.758021583979769
MACRO
AUC          : NaN
========Ranking Based Measures========
One-error    : 0.8147773279352227
Coverage     : 1.402901484480432
Ranking Loss : 0.40924055413979615
AvgPrecision : 0.5383646367299113

0.18776428250112462;0.4897998200629779;0.49685335132703556;0.6100989653621233;0.5472528510845309;0.4035087719298246;0.3392958456366339;0.46975142350142346;0.38979896287379173;0.28996679246679247;0.38437839937839935;0.31530202145934416;0.758021583979769;NaN;0.8147773279352227;1.402901484480432;0.40924055413979615;0.5383646367299113;
CLR
========Example Based Measures========
HammingLoss    : 0.14139676113360325
Accuracy       : 0.4739473684210527
Precision      : 0.49499999999999994
Recall         : 0.49632253711201085
Fmeasure       : 0.4954373455450485
SubsetAccuracy : 0.43178137651821863
========Label Based Measures========
MICRO
Precision    : 0.42066817685238744
Recall       : 0.20500975000975
F1           : 0.2730321251305171
MACRO
Precision    : 0.31234126984126986
Recall       : 0.15439227439227438
F1           : 0.19216151223504166
MICRO
AUC          : 0.6584688207980036
MACRO
AUC          : NaN
========Ranking Based Measures========
One-error    : 0.7890013495276654
Coverage     : 1.2311066126855599
Ranking Loss : 0.34794937714364205
AvgPrecision : 0.5740810075984275

0.14139676113360325;0.4739473684210527;0.49499999999999994;0.49632253711201085;0.4954373455450485;0.43178137651821863;0.42066817685238744;0.20500975000975;0.2730321251305171;0.31234126984126986;0.15439227439227438;0.19216151223504166;0.6584688207980036;NaN;0.7890013495276654;1.2311066126855599;0.34794937714364205;0.5740810075984275;
MLkNN
10 neighbours: 0.002898550724637681
========Example Based Measures========
HammingLoss    : 0.13153396311291046
Accuracy       : 0.43178137651821863
Precision      : 0.43178137651821863
Recall         : 0.43178137651821863
Fmeasure       : 0.43178137651821863
SubsetAccuracy : 0.43178137651821863
========Label Based Measures========
MICRO
Precision    : 0.0
Recall       : 0.0
F1           : 0.0
MACRO
Precision    : 0.0
Recall       : 0.0
F1           : 0.0
MICRO
AUC          : 0.6546140141800455
MACRO
AUC          : NaN
========Ranking Based Measures========
One-error    : 0.7944669365721997
Coverage     : 1.203306342780027
Ranking Loss : 0.3288617488807277
AvgPrecision : 0.5754249643059712

0.13153396311291046;0.43178137651821863;0.43178137651821863;0.43178137651821863;0.43178137651821863;0.43178137651821863;0.0;0.0;0.0;0.0;0.0;0.0;0.6546140141800455;NaN;0.7944669365721997;1.203306342780027;0.3288617488807277;0.5754249643059712;
MC-Copy
IncludeLabels
========Example Based Measures========
HammingLoss    : 0.1422514619883041
Accuracy       : 0.44439271255060725
Precision      : 0.45174313990103465
Recall         : 0.45392487629329736
Fmeasure       : 0.4527400794354885
SubsetAccuracy : 0.4292847503373819
========Label Based Measures========
MICRO
Precision    : 0.3253125237335764
Recall       : 0.08600515288015287
F1           : 0.13049926619694058
MACRO
Precision    : 0.2113888888888889
Recall       : 0.0806016206016206
F1           : 0.1089311151811152
MICRO
AUC          : 0.5518176819324788
MACRO
AUC          : NaN
========Ranking Based Measures========
One-error    : 0.8972334682860998
Coverage     : 1.843522267206478
Ranking Loss : 0.5833328013345034
AvgPrecision : 0.40268699668307795

0.1422514619883041;0.44439271255060725;0.45174313990103465;0.45392487629329736;0.4527400794354885;0.4292847503373819;0.3253125237335764;0.08600515288015287;0.13049926619694058;0.2113888888888889;0.0806016206016206;0.1089311151811152;0.5518176819324788;NaN;0.8972334682860998;1.843522267206478;0.5833328013345034;0.40268699668307795;
MC-Ignore
RAkEL
========Example Based Measures========
HammingLoss    : 0.13370445344129556
Accuracy       : 0.4780544309491678
Precision      : 0.5058479532163742
Recall         : 0.4955465587044534
Fmeasure       : 0.5004530064796333
SubsetAccuracy : 0.42672064777327934
========Label Based Measures========
MICRO
Precision    : 0.48846288515406167
Recall       : 0.271028431028431
F1           : 0.33994735290920797
MACRO
Precision    : 0.39524591149591154
Recall       : 0.22797535797535792
F1           : 0.2615064782711841
MICRO
AUC          : 0.6759669469084317
MACRO
AUC          : NaN
========Ranking Based Measures========
One-error    : 0.7941295546558704
Coverage     : 1.5420377867746289
Ranking Loss : 0.45902719109329526
AvgPrecision : 0.5129976266693514

0.13370445344129556;0.4780544309491678;0.5058479532163742;0.4955465587044534;0.5004530064796333;0.42672064777327934;0.48846288515406167;0.271028431028431;0.33994735290920797;0.39524591149591154;0.22797535797535792;0.2615064782711841;0.6759669469084317;NaN;0.7941295546558704;1.5420377867746289;0.45902719109329526;0.5129976266693514;
LP
========Example Based Measures========
HammingLoss    : 0.1697480881691408
Accuracy       : 0.41603238866396763
Precision      : 0.4450517318938371
Recall         : 0.43356950067476385
Fmeasure       : 0.4389535023197248
SubsetAccuracy : 0.37523616734143045
========Label Based Measures========
MICRO
Precision    : 0.29929319413031885
Recall       : 0.21641194766194766
F1           : 0.24901410361365559
MACRO
Precision    : 0.2273647186147186
Recall       : 0.17090386465386467
F1           : 0.18754692661426406
MICRO
AUC          : 0.617362155875687
MACRO
AUC          : NaN
========Ranking Based Measures========
One-error    : 0.8895411605937923
Coverage     : 1.9338731443994603
Ranking Loss : 0.6007444495896299
AvgPrecision : 0.4003663647787504

0.1697480881691408;0.41603238866396763;0.4450517318938371;0.43356950067476385;0.4389535023197248;0.37523616734143045;0.29929319413031885;0.21641194766194766;0.24901410361365559;0.2273647186147186;0.17090386465386467;0.18754692661426406;0.617362155875687;NaN;0.8895411605937923;1.9338731443994603;0.6007444495896299;0.4003663647787504;
MLStacking
========Example Based Measures========
HammingLoss    : 0.13242240215924425
Accuracy       : 0.46523391812865506
Precision      : 0.4924988753936123
Recall         : 0.4726608187134504
Fmeasure       : 0.48213920611711664
SubsetAccuracy : 0.43178137651821863
========Label Based Measures========
MICRO
Precision    : 0.4900396825396826
Recall       : 0.14277351214851214
F1           : 0.21405083655083654
MACRO
Precision    : 0.18240740740740738
Recall       : 0.1006655844155844
F1           : 0.12209220790103144
MICRO
AUC          : 0.6826577833986901
MACRO
AUC          : NaN
========Ranking Based Measures========
One-error    : 0.7607287449392712
Coverage     : 1.1618083670715247
Ranking Loss : 0.3193928875980364
AvgPrecision : 0.6006514440079371

0.13242240215924425;0.46523391812865506;0.4924988753936123;0.4726608187134504;0.48213920611711664;0.43178137651821863;0.4900396825396826;0.14277351214851214;0.21405083655083654;0.18240740740740738;0.1006655844155844;0.12209220790103144;0.6826577833986901;NaN;0.7607287449392712;1.1618083670715247;0.3193928875980364;0.6006514440079371;

