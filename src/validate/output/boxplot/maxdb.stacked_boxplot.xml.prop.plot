set key below
set style fill pattern
set terminal postscript eps enhanced color
set xtics rotate ( "portability" 0, "maintainability" 1, "efficiency" 2, "reliability" 3, "functionality" 4, "usability" 5 )
set output "output/maxdb.stacked_boxplot.xml.prop.eps"
plot [-0.5:5.5] [0:] \
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1088563753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1098931753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1119667753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1132627753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1142995753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1091155753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1101523753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1122259753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1135219753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1145587753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($12+$13+$14+$15+$16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1093747753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($13+$14+$15+$16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1104115753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($14+$15+$16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1124851753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($15+$16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1137811753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($16+$17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1148179753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($17+$18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1096339753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($18+$19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1106707753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($19+$20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1130035753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($20+$21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1140403753" with boxes,\
"output/maxdb.stacked_boxplot.xml.prop.dat" using 1:(($21)/(($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)+1e-160)) title "1150771753" with boxes
