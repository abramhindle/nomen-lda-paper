#!/bin/bash
DIR=`pwd`
mkdir wordlists
cd wordlists
python ../names.py
FILES=`echo wordlist.*`
WLDIR=`pwd`
cd ../../WordnetOcaml-0.1/
for file in $FILES
do
    echo $file
    cat $WLDIR/$file > $DIR/$file
    cat $WLDIR/$file | xargs sh related.sh >> $DIR/$file
done
