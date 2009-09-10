rm -rf pres-out
mkdir pres-out
awk '{print "convert -composite  white.png " $1 " pres-out/" (sprintf("%003d",FNR)) ".png"}' < order  | sh -x

