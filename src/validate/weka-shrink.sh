#!/bin/sh
# note: this file is for shrinking the huge files that weka generates
for file in output/maxdb.*.NaiveBayes.txt output/mysql.*.NaiveBayes.txt output/mysql.*.SMO.txt output/maxdb.*.SMO.txt 
do
	tail -n 55 $file > /tmp/tailed
	cp /tmp/tailed $file
done
