for exp in exp1 exp2 exp3; do echo $exp; for proj in pgsql; do echo $proj;egrep '^Total'  ../$exp/$proj.lda_relator.report; done; done
