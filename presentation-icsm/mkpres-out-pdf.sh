rm -rf pres-out/*.pdf
mkdir pres-out
#awk '{print "convert -composite  white.png " $1 " pres-out/" (sprintf("%003d",FNR)) ".png"}' < order  | sh -x
awk '{print "cp " $1 " pres-out/" (sprintf("%003d",FNR)) ".pdf"}' < order  | sh -x
pdfjoin --outfile pres1.pdf pres-out/*.pdf
