#!/bin/sh
# this generates page number PDF target names. It doesn't make the file
# make uses this file
N=$1
if [ -z $N ]; then
    N=`sh number-of-slides.sh`
fi
seq  1 $N | sed -e 's/^/numbers\//' | sed -e 's/$/.pdf/'

