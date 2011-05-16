#!/bin/sh
FILE=$1
NUMBER=`echo $FILE | sed -e 's/.svg//' | sed -e 's/^[^0-9]*//'`
echo $FILE $NUMBER
sed -e s/ZZ/$NUMBER/ number.svg > $FILE
