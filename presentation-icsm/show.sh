find -iname '*.png' -or -iname '*.jpg' | sort -n | fgrep -v notused | XARGS feh -Z 
