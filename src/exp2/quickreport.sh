for report in ../counts/*report
do 
	echo $report
	cp $report ./lda.report
	for file in wordlist.*; do echo $file; sh quickcount.sh $file; done | egrep -v ' 0$'
done
