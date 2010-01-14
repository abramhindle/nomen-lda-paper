#!/bin/bash
# first arg is an arff name in output/ (not extension)
BASE=output
mkdir $BASE
mkdir $BASE/tmp
FILE=$1
ATTRS=`egrep '^@ATTRIBUTE ' $BASE/$FILE.arff | wc -l`
WATTRS=`egrep '^@ATTRIBUTE W_' $BASE/$FILE.arff | wc -l`
AATTRS=`egrep '^@ATTRIBUTE A_' $BASE/$FILE.arff | wc -l`
AATTRSSTART=`expr $WATTRS + 1`
ATTRL=`seq $AATTRSSTART $ATTRS`
ALL=""
for file in $ATTRL
do
	ARFF=$BASE/tmp/$FILE.$file.arff 
	echo ${ARFF}: $BASE/$FILE.arff
	echo -e "\tjava" -cp weka-36.jar weka.filters.unsupervised.attribute.Remove -V -R 1-${WATTRS},$file -i $BASE/$FILE.arff -o ${ARFF}
	for classifier in `cat weka-classifiers`
	do
		REPORT=output/mysql.$file.$classifier.txt 
		echo "$REPORT:" ${ARFF}
		echo -e "\tsh" -x weka-classifier.sh $classifier -i -t $ARFF -c last \| tee $REPORT
		ALL="$REPORT $ALL"
	done
done
echo "all: $ALL"
