for project in `cat projects`
do
	cat $project/*J48*report | perl grepwords.pl | perl wordcount.pl  > $project/cloud.html
	cat $project/*J48*report | perl grepwords.pl | perl wordcounttex.pl  > $project/cloud.tex
        cd $project
        pdflatex cloud.tex
        pdfcrop cloud.pdf
        cd ..
done
