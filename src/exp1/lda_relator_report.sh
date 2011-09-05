#for proj in mysql maxdb pgsql
for proj in pgsql
do
	cp ../counts/$proj.lda.report ./lda.report
	~/projects/hiraldo_grok/hs/Lda_relator  > $proj.lda_relator.report
done
