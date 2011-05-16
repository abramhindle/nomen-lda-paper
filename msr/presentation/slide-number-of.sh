#!/bin/bash
FILE=`basename $1 | sed -e 's/\.pdf//'`
find order -type f -or -type l | sort -n | awk '{print NR " " $0}' | fgrep "$FILE" | awk '{print $1}'
