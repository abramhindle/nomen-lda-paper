set key below
set style fill pattern
set terminal postscript eps enhanced color "NimbusSanL-Regu" fontfile "/usr/share/texmf-tetex/fonts/type1/urw/helvetic/uhvr8a.pfb"
set xtics rotate ( "Corrective" 0, "Adaptive" 1, "Perfective" 2, "Non Functional" 3, "Implementation" 4 )
set output "./boxplot-test-prop.eps"
plot [-0.5:4.5] [0:] \
"./boxplot-test-prop.dat" using 1:(($2+$3+$4+$5+$6+$7+$8+$9+$10)/($2+$3+$4+$5+$6+$7+$8+$9+$10)) title "boost" with boxes,\
"./boxplot-test-prop.dat" using 1:(($3+$4+$5+$6+$7+$8+$9+$10)/($2+$3+$4+$5+$6+$7+$8+$9+$10)) title "egroupware" with boxes,\
"./boxplot-test-prop.dat" using 1:(($4+$5+$6+$7+$8+$9+$10)/($2+$3+$4+$5+$6+$7+$8+$9+$10)) title "enlightenment" with boxes,\
"./boxplot-test-prop.dat" using 1:(($5+$6+$7+$8+$9+$10)/($2+$3+$4+$5+$6+$7+$8+$9+$10)) title "evolution" with boxes,\
"./boxplot-test-prop.dat" using 1:(($6+$7+$8+$9+$10)/($2+$3+$4+$5+$6+$7+$8+$9+$10)) title "firebird" with boxes,\
"./boxplot-test-prop.dat" using 1:(($7+$8+$9+$10)/($2+$3+$4+$5+$6+$7+$8+$9+$10)) title "mysql-5_0" with boxes,\
"./boxplot-test-prop.dat" using 1:(($8+$9+$10)/($2+$3+$4+$5+$6+$7+$8+$9+$10)) title "postgresql" with boxes,\
"./boxplot-test-prop.dat" using 1:(($9+$10)/($2+$3+$4+$5+$6+$7+$8+$9+$10)) title "samba" with boxes,\
"./boxplot-test-prop.dat" using 1:(($10)/($2+$3+$4+$5+$6+$7+$8+$9+$10)) title "springframework" with boxes
