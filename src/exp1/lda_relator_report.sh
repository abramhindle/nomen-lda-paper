for proj in mysql maxdb
do
	cp ../counts/$proj.lda.report ./lda.report
	~/projects/hiraldo_grok/hs/Lda_relator  > $proj.lda_relator.report
done
