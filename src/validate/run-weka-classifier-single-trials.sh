#!/bin/bash
# We make experimental make files
# We run each annotation against each classifier
CPUS=4
bash make-single-class-arff-files.sh mysql > Makefile.mysql && make -f Makefile.mysql -j $CPUS all
bash make-single-class-arff-files.sh maxdb > Makefile.maxdb && make -f Makefile.maxdb -j $CPUS all
bash make-single-class-arff-files.sh maxdb__mysql > Makefile.maxdb__mysql && make -f Makefile.maxdb__mysql -j $CPUS all
