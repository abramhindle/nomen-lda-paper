set key below
set style fill pattern
set terminal postscript eps enhanced color
set xtics rotate ( "portability" 0, "maintainability" 1, "efficiency" 2, "reliability" 3, "functionality" 4, "usability" 5 )
set output "output/maxdb.period.1093747753.boxplot.xml.prop.eps"
plot [-0.5:5.5] [0:] \
"output/maxdb.period.1093747753.boxplot.xml.prop.dat" using 1:(($2)/(($2)+1e-160)) title "1093747753" with boxes
