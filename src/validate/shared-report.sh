cat output/mysql.*J48.txt | perl grepwords.pl | sort > output/mysql-j48-words
cat output/maxdb.*J48.txt | perl grepwords.pl | sort > output/maxdb-j48-words
fgrep -if output/maxdb-j48-words output/mysql-j48-words | sort | uniq -c | sort -n > output/shared-j48-words
