for file in wordlist.*; do echo $file; sh quickcount.sh $file; done | egrep -v ' 0$'
