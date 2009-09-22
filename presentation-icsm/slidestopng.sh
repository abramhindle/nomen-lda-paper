make
convert presentation.out.pdf -scale 1024x768 presentation.out.png
for file in slide*.svg
do
	inkscape -w 1024 --export-png=$file.png $file
done
for file in month.png time-smear-plot.png fixed-time-smear-plot-cropped.png class-smear-plot-crop-scaled.png histogram-cropped-scaled.png
do
	convert $file -scale 1024x768 $file.slide.png
done
