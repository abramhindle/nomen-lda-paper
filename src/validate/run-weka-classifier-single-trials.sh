#!/bin/bash
# We make experimental make files
# We run each annotation against each classifier
make -f Makefile.run-weka-classifier-single-trials all
exit
CPUS=3
perl make-single-class-arff-files.pl pgsqla && make -f Makefile.pgsqla -j $CPUS all
perl make-single-class-arff-files.pl pgsqln && make -f Makefile.pgsqln -j $CPUS all
#perl make-single-class-arff-files.pl pgsql && make -f Makefile.pgsql -j $CPUS all
perl make-single-class-arff-files.pl mysql && make -f Makefile.mysql -j $CPUS all
perl make-single-class-arff-files.pl maxdb && make -f Makefile.maxdb -j $CPUS all
#perl make-single-class-arff-files.pl maxdb__mysql && make -f Makefile.maxdb__mysql -j $CPUS all
