make
#convert presentation.out.pdf -scale 1024x768 presentation.out.png
pdftk presentation.out.pdf burst output presentation.out-%02d.pdf
for file in slide*.svg
do
#	inkscape -w 1024 --export-pdf=$file.pdf $file
	inkscape --export-pdf=$file.pdf $file
done
for file in month.png time-smear-plot.png fixed-time-smear-plot-cropped.png class-smear-plot-crop-scaled.png histogram-cropped-scaled.png
do
	convert $file -scale 1024x768 $file.slide.pdf
done
