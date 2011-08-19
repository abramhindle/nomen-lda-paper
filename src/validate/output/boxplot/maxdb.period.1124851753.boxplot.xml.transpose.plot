set key below
set style fill pattern
set terminal postscript eps enhanced color
set xtics rotate ( "1124851753" 0 )
set output "output/maxdb.period.1124851753.boxplot.xml.transpose.eps"
plot [-0.5:0.5] [0:] \
"output/maxdb.period.1124851753.boxplot.xml.transpose.dat" using 1:($2+$3+$4+$5+$6+$7) title "portability" with boxes,\
"output/maxdb.period.1124851753.boxplot.xml.transpose.dat" using 1:($3+$4+$5+$6+$7) title "maintainability" with boxes,\
"output/maxdb.period.1124851753.boxplot.xml.transpose.dat" using 1:($4+$5+$6+$7) title "efficiency" with boxes,\
"output/maxdb.period.1124851753.boxplot.xml.transpose.dat" using 1:($5+$6+$7) title "reliability" with boxes,\
"output/maxdb.period.1124851753.boxplot.xml.transpose.dat" using 1:($6+$7) title "functionality" with boxes,\
"output/maxdb.period.1124851753.boxplot.xml.transpose.dat" using 1:($7) title "usability" with boxes
