#!/bin/sh
# note: this file is for shrinking the huge files that weka generates
for file in output/*.*.NaiveBayes.txt output/*.*.SMO.txt 
do
	tail -n 55 $file > /tmp/tailed
	cp /tmp/tailed $file
done
