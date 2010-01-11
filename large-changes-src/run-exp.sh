ALL=""
for project in `cat projects` everything
#for project in everything
do
	for classifier in `cat weka-classifiers`
	do 
		for category in Swanson detail large STBD
		do
			OUTFILE=$project/$category.$classifier.report
			echo ${OUTFILE}:
			echo "\tsh weka-classifier.sh" $classifier -i -t $project/$category.arff -c 1 \> $project/$category.$classifier.report
			ALL="$ALL ${OUTFILE}"
		done
	done
done

for prefix in dir big wauthor noauthor onlyauthor onlydir
do
    for project in `cat projects` everything
    #for project in everything
    do
    	for classifier in `cat weka-classifiers`
    	do 
    		for category in Swanson detail large STBD
    		do
    			OUTFILE=$project/$prefix.$category.$classifier.report
    			DATAFILE=$project/$prefix.$category.arff
    			echo ${OUTFILE}:
    			echo "\tsh weka-classifier.sh" $classifier -i -t $DATAFILE -c 1 \> $OUTFILE
    			ALL="$ALL ${OUTFILE}"
    		done
    	done
    done
done


echo "all: $ALL"
