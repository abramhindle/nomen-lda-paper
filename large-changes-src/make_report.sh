#!/bin/sh -x -e
cat file_list | xargs perl project_report.pl Everything 
cat file_list | xargs perl project_report.pl Proportional
for file in `cat projects`
do
	echo Processing $file
	perl project_report.pl $file $file/*
	perl project_report.pl -p $file $file/*
done
perl plotter.sh
