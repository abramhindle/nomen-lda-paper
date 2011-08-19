set key below
set style fill pattern
set terminal postscript eps enhanced color
set xtics rotate ( "portability" 0, "maintainability" 1, "efficiency" 2, "reliability" 3, "functionality" 4, "usability" 5 )
set output "output/maxdb.period.1106707753.boxplot.xml.eps"
plot [-0.5:5.5] [0:] \
"output/maxdb.period.1106707753.boxplot.xml.dat" using 1:($2) title "1106707753" with boxes
