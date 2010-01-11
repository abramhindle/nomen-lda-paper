make
fgrep '' reports/*Swanson-report.txt | sed -e 's/|//' | sed -e 's/reports\///' | sed -e 's/-.*\.txt:/\t/' | tee reports/summary.txt
