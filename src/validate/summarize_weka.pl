#!/usr/bin/perl
# Sorry neil but this shit was already written ;)
use List::Util qw(sum max min reduce);
use strict;
my @mprojects = slurp('projects');
my @columns = slurp('project-columns');
my %cols = ();
foreach my $column (@columns) {
    chomp($column);
    my ($project,$start,$end) = split(/\s+/,$column);
    $cols{$project}->{start} = $start;
    $cols{$project}->{end} = $end;
}
my @learners = slurp('weka-classifiers');

my $ZEROR = "weka.classifiers.rules.ZeroR";
my $latex_dir = "latex-out";
my ($DONE,$NOTFOUND,$STRATIFIED,$CORRECT,$INCORRECT,$WEIGHTED) = (1..100);

my $dir="";

sub proj_columns {
    my $project = shift;
    return ($cols{$project}->{start}..$cols{$project}->{end});
}

my %hash = ();
mkdir($latex_dir);
my $table_file = "${latex_dir}/table.tex";
{
    open(my $fd, ">", $table_file) or die "Couldn't open $table_file";
    foreach my $project (@projects) {
        warn $project;
        foreach my $column (proj_columns($project)) {
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
                my $projectname = TagMap::get_project_name($project);
                ($percent,$ipercent) = map { sprintf('%0.2f',$_) } ($percent,$ipercent);
                print $fd join(" & ", $projectname , $learnername , $percent, $ipercent, $count, $icount)." \\\\ $/";
                
            }
        }
    }
    close($fd);
}

{
    foreach my $project (@projects) {
        open(my $fd, ">", "latex-out/$project-column-learner-table.tex");
        foreach my $column (proj_columns($project)) {
            foreach my $learner (@learners) {
                my @correct = map { $hash{$_}->{$column}->{$learner}->{percent}  } @projects;
                my ($avg, $var, $std, $min, $max, $sum, $n) = stats(@correct);
                my $learnername = learner_name($learner);
                print $fd join(" & ", $column, $learnername, $avg, $std, $min, $max)." \\\\ $/";
            }
        }
        close($fd);
    }
}

# This doesn't make sense to me 
#{
#
#    open(my $fd, ">", "latex-out/best-avg-learner-table.tex");
#    warn 'open(my $fd, ">", "latex-out/best-avg-learner-table.tex");';
#    
#    foreach my $category (@categories) {
#        my $bestlearner = $learners[0];
#        my $bestlearnerv = 0;
#        foreach my $learner (@learners) {
#            my @correct = map { $hash{$_}->{$category}->{$learner}->{percent}  } @projects;
#            my ($avg, $var, $std, $min, $max, $sum, $n) = stats(@correct);
#            if ($avg >  $bestlearnerv) {
#                $bestlearner = $learner;
#                $bestlearnerv = $avg;
#            }
#        }
#        my $catname = TagMap::tag_map($category);
#        my $learnername = learner_name($bestlearner);
#        
#        my @zeror = map { $hash{$_}->{$category}->{$bestlearner}->{zerorpercent} } @projects;
#        my @zerordiff = map { $hash{$_}->{$category}->{$bestlearner}->{zerordiff} } @projects;
#        my @fmeasure = map { $hash{$_}->{$category}->{$bestlearner}->{fmeasure} } @projects;
#        my @roc = map { $hash{$_}->{$category}->{$bestlearner}->{roc} } @projects;
#        
#        my ($zeror_avg) = stats(@zeror);
#        my ($zerordiff_avg) = stats(@zerordiff);
#        my ($fmeasure_avg) = stats(@fmeasure);
#        my ($roc_avg) = stats(@roc);
#        
#        
#        
#        print $fd " & ".join(" &  ", $catname, $learnername, (map { format_float($_) } ($bestlearnerv, $zeror_avg, $zerordiff_avg, $fmeasure_avg, $roc_avg)))." \\\\ $/";
#    }
#    close($fd);
#}

{
    # note we're going to have to extract column names
    open(my $fd, ">", "latex-out/best-learner-per-project-table.tex");
    warn "open(my \$fd, '>', 'latex-out/best-learner-per-project-table.tex');";
    foreach my $project (@projects) {
        foreach my $column (proj_columns($project)) {
            my $bestlearner = $learners[0];
            my $bestlearnerv = 0;
    
            foreach my $learner (@learners) {
                my $correct = $hash{$project}->{$column}->{$learner}->{percent};
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
        foreach my $column (proj_columns($project)) {

            my $bestlearner = $hash{$project}->{$column}->{best_learner}->{name};
            my $bestlearnerv = $hash{$project}->{$column}->{best_learner}->{val};
            my $zeror = $hash{$project}->{$column}->{$bestlearner}->{zerorpercent};
            my $zerordiff = $hash{$project}->{$column}->{$bestlearner}->{zerordiff};
            my $fmeasure = $hash{$project}->{$column}->{$bestlearner}->{fmeasure};
            my $roc = $hash{$project}->{$column}->{$bestlearner}->{roc};
            my $projectname = TagMap::get_project_name($project);
            my $catname = TagMap::get_short_tag_name($column);
            my $learnername = learner_name($bestlearner);
            #print $fd join(" &  ", $projectname, $catname, $learnername, (map { format_float($_) } ($bestlearnerv , $zeror, $zerordiff, $fmeasure, $roc)))." \\\\ $/";
            print $fd join(" &  ", $catname, $projectname, $learnername, (map { format_float($_) } ($bestlearnerv , $zeror, $zerordiff, $fmeasure, $roc)))." \\\\ $/";
        }
        print $fd " \\hline $/";
    }
    
    close($fd);
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
    my ($tp,$fp,$precision,$recall,$fmeasure, $roc) = (0,0,0,0,0,0);
    while($state != $DONE) {
        my $line = <$fd>;
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

                $state = $WEIGHTED;
            } elsif ($line =~ /Confusion Matrix/) {
                $state = $WEIGHTED;
            }
        } elsif ($state == $WEIGHTED) {
            $state = $DONE;
        } else {
            die "Bad state! [$state]";
        }
    }
    die "Ended on the wrong state! Ours:[$state] vs wanted:[$DONE]" unless $state == $DONE;
    return (
            correct => $correct_count,
            percent => $correct_percent,
            incorrect => $incorrect_count,
            ipercent => $incorrect_percent,
            roc => $roc,
            tp => $tp,
            fp => $fp,
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
