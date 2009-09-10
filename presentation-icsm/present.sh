find pres-out -iname '*.png' -or -iname '*.jpg' | sort -n | fgrep -v notused | XARGS feh  -b white.png -F -Z  -a 0
