for project in `cat projects`
do
	cat output/$project.*J48.txt | perl grepwords.pl | perl wordcount.pl     > output/$project-cloud.html
	cat output/$project.*J48.txt | perl grepwords.pl | perl wordcounttex.pl  > output/$project-cloud.tex
        cd output
        pdflatex $project-cloud.tex
        pdfcrop  $project-cloud.pdf
        cd ..
done
