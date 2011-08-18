set key below
set style fill pattern
set terminal postscript eps enhanced color
set xtics rotate ( "1088563753" 0, "1098931753" 1, "1119667753" 2, "1132627753" 3, "1142995753" 4, "1091155753" 5, "1101523753" 6, "1122259753" 7, "1135219753" 8, "1145587753" 9, "1093747753" 10, "1104115753" 11, "1124851753" 12, "1137811753" 13, "1148179753" 14, "1096339753" 15, "1106707753" 16, "1130035753" 17, "1140403753" 18, "1150771753" 19 )
set output "output/maxdb.stacked_boxplot.xml.transpose.eps"
plot [-0.5:19.5] [0:] \
"output/maxdb.stacked_boxplot.xml.transpose.dat" using 1:($2+$3+$4+$5+$6+$7) title "portability" with boxes,\
"output/maxdb.stacked_boxplot.xml.transpose.dat" using 1:($3+$4+$5+$6+$7) title "maintainability" with boxes,\
"output/maxdb.stacked_boxplot.xml.transpose.dat" using 1:($4+$5+$6+$7) title "efficiency" with boxes,\
"output/maxdb.stacked_boxplot.xml.transpose.dat" using 1:($5+$6+$7) title "reliability" with boxes,\
"output/maxdb.stacked_boxplot.xml.transpose.dat" using 1:($6+$7) title "functionality" with boxes,\
"output/maxdb.stacked_boxplot.xml.transpose.dat" using 1:($7) title "usability" with boxes
