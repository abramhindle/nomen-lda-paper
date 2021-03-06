#!/usr/bin/perl
# Sorry neil but this shit was already written ;)
use List::Util qw(sum max min reduce);
use strict;
my @mprojects = slurp('projects');
my @projects = @mprojects;
my @categories = slurp('categories');
my %cols = ();
#foreach my $column (@columns) {
#    chomp($column);
#    my ($project,$start,$end) = split(/\s+/,$column);
#    $cols{$project}->{start} = $start;
#    $cols{$project}->{end} = $end;
#}
my @learners = slurp('weka-classifiers');

my $ZEROR = "weka.classifiers.rules.ZeroR";
my $latex_dir = "latex-out";
my ($DONE,$NOTFOUND,$STRATIFIED,$CORRECT,$INCORRECT,$CONFUSION,$WEIGHTED) = (1..100);

my $dir="";

#sub proj_columns {
#    my $project = shift;
#    return ($cols{$project}->{start}..$cols{$project}->{end});
#}

my %hash = ();
mkdir($latex_dir);
my $table_file = "${latex_dir}/table.tex";
{
    open(my $fd, ">", $table_file) or die "Couldn't open $table_file";
    foreach my $project (@projects) {
        warn $project;
        foreach my $column (@categories) {
            my %zero = get_correct_incorrect($project,$column,$ZEROR);
            foreach my $learner (@learners) {
                my %ret = get_correct_incorrect($project,$column,$learner,$dir);
                my ($count,$percent,$icount,$ipercent, $precision, $recall, $fmeasure, $roc) = @ret{qw(correct percent incorrect ipercent precision recall fmeasure roc)};
                
                $hash{$project}->{$column}->{$learner}->{zerorpercent} = $zero{percent};
                $hash{$project}->{$column}->{$learner}->{zerordiff} = $percent - $zero{percent};
                $hash{$project}->{$column}->{$learner}->{count} = $count;
                $hash{$project}->{$column}->{$learner}->{icount} = $icount;
                $hash{$project}->{$column}->{$learner}->{percent} = $percent;
                $hash{$project}->{$column}->{$learner}->{precision} = $precision;
                $hash{$project}->{$column}->{$learner}->{recall} = $recall;
                $hash{$project}->{$column}->{$learner}->{fmeasure} = $fmeasure;
                $hash{$project}->{$column}->{$learner}->{roc} = $roc;
                
                my $learnername = learner_name($learner);
                my $projectname = $project;#TagMap::get_project_name($project);
                ($percent,$ipercent) = map { sprintf('%0.2f',$_) } ($percent,$ipercent);
                print $fd join(" & ", $projectname , $column, $learnername , $roc, $percent, $ipercent, $count, $icount)." \\\\ $/";
                
            }
        }
    }
    close($fd);
}
my @measures = qw(percent roc recall precision fmeasure);
{ # this doesn't make sense til we unify columns!
    foreach my $project (@projects) {
        foreach my $measure (@measures) {
            open(my $fd, ">", "${latex_dir}/$project-column-learner-${measure}-table.tex");
            foreach my $column (@categories) {
                foreach my $learner (@learners) {
                    my @correct = map { $hash{$_}->{$column}->{$learner}->{$measure}  } @projects;
                    my ($avg, $var, $std, $min, $max, $sum, $n) = stats(@correct);
                    my $learnername = learner_name($learner);
                    print $fd join(" & ", $column, $learnername, $avg, $std, $min, $max)." \\\\ $/";
                }
            }
            close($fd);
        }
    }
}

# This doesn't make sense to me 
 {
 
     foreach my $measure (@measures) {

         open(my $fd, ">", "${latex_dir}/best-avg-learner-${measure}-table.tex");
         warn 'open(my $fd, ">", "${latex_dir}/best-avg-learner-${measure}-table.tex");';
     
         foreach my $category (@categories) {
             my $bestlearner = $learners[0];
             my $bestlearnerv = 0;
             foreach my $learner (@learners) {
                 my @correct = map { $hash{$_}->{$category}->{$learner}->{$measure}  } @projects;
                 my ($avg, $var, $std, $min, $max, $sum, $n) = stats(@correct);
                 if ($avg >  $bestlearnerv) {
                     $bestlearner = $learner;
                     $bestlearnerv = $avg;
                 }
             }
             my $catname = $category;#TagMap::tag_map($category);
             my $learnername = learner_name($bestlearner);
         
             my @zeror = map { $hash{$_}->{$category}->{$bestlearner}->{zerorpercent} } @projects;
             my @zerordiff = map { $hash{$_}->{$category}->{$bestlearner}->{zerordiff} } @projects;
             my @fmeasure = map { $hash{$_}->{$category}->{$bestlearner}->{fmeasure} } @projects;
             my @roc = map { $hash{$_}->{$category}->{$bestlearner}->{roc} } @projects;
         
             my ($zeror_avg) = stats(@zeror);
             my ($zerordiff_avg) = stats(@zerordiff);
             my ($fmeasure_avg) = stats(@fmeasure);
             my ($roc_avg) = stats(@roc);
         
         
         
             print $fd " & ".join(" &  ", $catname, $learnername, (map { format_float($_) } ($bestlearnerv, $zeror_avg, $zerordiff_avg, $fmeasure_avg, $roc_avg)))." \\\\ $/";
         }
         close($fd);
     }
 }

{
    foreach my $measure (@measures) {
        # note we're going to have to extract column names
        open(my $fd, ">", "latex-out/best-learner-per-project-${measure}-table.tex");
        warn "open(my \$fd, '>', 'latex-out/best-learner-per-project-${measure}-table.tex');";
        foreach my $project (@projects) {
            foreach my $column (@categories) {
                my $bestlearner = $learners[0];
                my $bestlearnerv = 0;
                
                foreach my $learner (@learners) {
                    my $correct = $hash{$project}->{$column}->{$learner}->{$measure};
                    if ($correct >  $bestlearnerv) {
                        $bestlearner = $learner;
                        $bestlearnerv = $correct;
                    }
                }
                $hash{$project}->{$column}->{best_learner}->{name} = $bestlearner;
                $hash{$project}->{$column}->{best_learner}->{val} = $bestlearnerv;
                
            }
        }
        foreach my $project (@projects) {
            foreach my $column (@categories) {
                
                my $bestlearner = $hash{$project}->{$column}->{best_learner}->{name};
                my $bestlearnerv = $hash{$project}->{$column}->{best_learner}->{val};
                my $zeror = $hash{$project}->{$column}->{$bestlearner}->{zerorpercent};
                my $zerordiff = $hash{$project}->{$column}->{$bestlearner}->{zerordiff};
                my $fmeasure = $hash{$project}->{$column}->{$bestlearner}->{fmeasure};
                my $roc = $hash{$project}->{$column}->{$bestlearner}->{roc};
                my $projectname = $project;#TagMap::get_project_name($project);
                my $catname = $column;#TagMap::get_short_tag_name($column);
                my $learnername = learner_name($bestlearner);
                #print $fd join(" &  ", $projectname, $catname, $learnername, (map { format_float($_) } ($bestlearnerv , $zeror, $zerordiff, $fmeasure, $roc)))." \\\\ $/";
                print $fd join(" &  ", $catname, $projectname, $learnername, (map { format_float($_) } ($bestlearnerv , $zeror, $zerordiff, $fmeasure, $roc)))." \\\\ $/";
            }
            print $fd " \\hline $/";
        }
        
        close($fd);
    }

}



sub precision {
    my ($tp,$fp) = @_;
    if ($tp + $fp == 0) { return 0 }
    return $tp / (1.0 * $tp + $fp)
}
sub recall { 
    my ($tp,$fn) = @_;
    if ($tp + $fn == 0){ return 0 }
    return $tp / (1.0 * $tp + $fn)
}
sub true_negative_rate { 
    my ($tn,$fp) = @_;
    return $tn / (1.0 * $tn + $fp)
}
sub specificity { 
    my ($tn,$fp) = @_;
    return true_negative_rate($tn,$fp)
}
sub false_positive_rate {
    my ($fp,$tn) = @_;
    return $fp / (1.0*($fp + $tn))
}
sub accuracy { 
    my ($tp,$tn,$fp,$fn) = @_;
    return ($tp + $tn)/ (1.0 * $tp + $tn + $fp + $fn);
}
sub true_positive_rate {
    my ($tp,$fn) = @_;
    return $tp /(1.0 * ( $tp + $fn))
}
sub sensitivity { 
    my ($tp,$fn) = @_;
    return true_positive_rate($tp,$fn)
}
sub fmeasure{
    my ($precision,$recall) = @_;
    if ($precision + $recall == 0){ return 0 }
    return 2.0 * ($precision * $recall) / (1.0 * ($precision + $recall))
}




sub format_float {
    sprintf('%0.2f',$_[0])
}

sub learner_name {
    my @a = split(/\./,$_[0]);
    return pop @a;
}
sub get_correct_incorrect {
    my ($project,$column,$learner) = @_;
    $dir = (defined $dir)?"${dir}.":"";
    #mysql.17587.weka.classifiers.rules.JRip.txt
    #project.column.$classifier.txt
    my $filename = "output/${project}.${column}.${learner}.txt";
    warn $filename;
    open(my $fd, $filename) or die "Couldn't open $filename";
    my $state = $NOTFOUND;
    my $correct_count = 0;
    my $correct_percent = 0;
    my $incorrect_count = 0;
    my $incorrect_percent = 0;
    my ($tp,$fp,$precision,$recall,$fmeasure, $roc,$tn,$fn) = (0,0,0,0,0,0,0,0,0);
    while($state != $DONE) {
        my $line = <$fd>;
	$state = $DONE unless defined $line;	
        chomp($line);
        if ($state == $NOTFOUND) {
            if ($line =~ /Stratified/) {
                $state = $STRATIFIED;
            }
        } elsif ($state == $STRATIFIED) {
            if ($line =~ /Correctly Classified Instances\s*(\d+)\s*([\d\.]+)\s*%/) {
                $correct_count = $1;
                $correct_percent = $2;
                $state = $CORRECT;
            }
        } elsif ($state == $CORRECT) {
            if ($line =~ /Incorrectly Classified Instances\s*(\d+)\s*([\d\.]+)\s*%/) {
                $incorrect_count = $1;
                $incorrect_percent = $2;
                $state = $INCORRECT;
                #last;
            }
        } elsif ($state == $INCORRECT) {
            if ($line =~ /Weighted Avg.\s*(.*)\s*$/) {
                my $vals = $1;
                $vals =~ s/^\s*//;
                $vals =~ s/\s*$//;
                ($tp,$fp,$precision,$recall,$fmeasure,$roc) = split(/\s+/,$vals);
                warn "Weighted AVG    ($tp,$fp,$precision,$recall,$fmeasure,$roc) = splits(/\s+/,$vals)";

                $state = $CONFUSION;
            } elsif ($line =~ /Confusion Matrix/) {
                $state = $CONFUSION;
            }
        } elsif ($state == $CONFUSION) {
            if ($line =~ /Confusion Matrix/) {
                $state = $CONFUSION;
            } elsif ($line =~ /^\s*$/) {
                #nothing
            } elsif ($line =~ /classified as/) {
                #nothing
            } elsif ($line =~ /^\s*(\d+\.?\d*)\s+(\d+\.?\d*)\s*\|\s*(\w)\s*=/) {
                my ($a,$b,$c) = ($1,$2,$3);
                if ($c eq "a") {
                    $tn = $a; #true negative true a not b
                    $fp = $b; # is an a but classified as a b
                } elsif ($c eq "b") {
                    $fn = $a;# is a b but classified as an a
                    $tp = $b;# is a b but is a b
                    $state = $DONE;
                }
            }

        } elsif ($state == $WEIGHTED) {
            $state = $DONE;
        } elsif ($state == $DONE) {
	    #must've been an empty file
        } else {
            die "Bad state! [$state]";
        }
    }
    $precision = precision($tp,$fp);
    $recall    = recall($tp,$fn);
    $fmeasure  = fmeasure($precision, $recall);
    die "Ended on the wrong state! Ours:[$state] vs wanted:[$DONE]" unless $state == $DONE;
    return (
            correct => $correct_count,
            percent => $correct_percent,
            incorrect => $incorrect_count,
            ipercent => $incorrect_percent,
            roc => $roc,
            tp => $tp,
            fp => $fp,
            tn => $tn,
            fn => $fn,
            precision => $precision,
            recall => $recall,
            fmeasure => $fmeasure,
            roc => $roc,
            file => $filename, #might have to remove this
           );
}

sub slurp {
    open(SLURPFD,$_[0]) or die "can't open $_[0]";
    my @lines = <SLURPFD>;
    chomp(@lines);
    return @lines;
}
sub stats {
    my @correct = @_;
    my $n = @correct;
    my $sum = sum(@correct);
    my $avg = $sum / (1.0*$n);
    warn "$sum $avg [@correct]";
    my $sumvar = reduce { my $a = $_ - $avg; $a * $a } @correct;
    my $var = $sumvar / $n;
    my $std = sqrt($var);
    my $min = min(@correct);
    my $max = max(@correct);
    return ($avg, $var, $std, $min, $max, $sum, $n);
}
