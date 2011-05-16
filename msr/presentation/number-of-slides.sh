#!/bin/sh
find order -type f -or -type l | sort -n  | wc -l
