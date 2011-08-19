set key below
set style fill pattern
set terminal postscript eps enhanced color
set xtics rotate ( "1148179753" 0 )
set output "output/maxdb.period.1148179753.boxplot.xml.transpose.prop.eps"
plot [-0.5:0.5] [0:] \
"output/maxdb.period.1148179753.boxplot.xml.transpose.prop.dat" using 1:(($2+$3+$4+$5+$6+$7)/(($2+$3+$4+$5+$6+$7)+1e-160)) title "portability" with boxes,\
"output/maxdb.period.1148179753.boxplot.xml.transpose.prop.dat" using 1:(($3+$4+$5+$6+$7)/(($2+$3+$4+$5+$6+$7)+1e-160)) title "maintainability" with boxes,\
"output/maxdb.period.1148179753.boxplot.xml.transpose.prop.dat" using 1:(($4+$5+$6+$7)/(($2+$3+$4+$5+$6+$7)+1e-160)) title "efficiency" with boxes,\
"output/maxdb.period.1148179753.boxplot.xml.transpose.prop.dat" using 1:(($5+$6+$7)/(($2+$3+$4+$5+$6+$7)+1e-160)) title "reliability" with boxes,\
"output/maxdb.period.1148179753.boxplot.xml.transpose.prop.dat" using 1:(($6+$7)/(($2+$3+$4+$5+$6+$7)+1e-160)) title "functionality" with boxes,\
"output/maxdb.period.1148179753.boxplot.xml.transpose.prop.dat" using 1:(($7)/(($2+$3+$4+$5+$6+$7)+1e-160)) title "usability" with boxes
