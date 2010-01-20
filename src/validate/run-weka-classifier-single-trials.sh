#!/bin/bash
# We make experimental make files
# We run each annotation against each classifier
CPUS=4
perl make-single-class-arff-files.pl mysql && make -f Makefile.mysql -j $CPUS all
perl make-single-class-arff-files.pl maxdb && make -f Makefile.maxdb -j $CPUS all
perl make-single-class-arff-files.pl maxdb__mysql && make -f Makefile.maxdb__mysql -j $CPUS all
