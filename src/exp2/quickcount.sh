cat $* | xargs -i echo echo -n \"{} \" \; fgrep -i \"{}\" lda.report \| wc -l | sh | sort -n -r -k 2
