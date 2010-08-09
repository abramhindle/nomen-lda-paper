IMAGES=
default: view

view: icse2011.pdf
	xpdf $<

icse2011-pre.pdf: icse2011.tex icpc.bib
	#	pdflatex icse2011
	#pdflatex icse2011
	#bibtex icse2011
	#pdflatex icse2011
	#pdflatex icse2011
	#mv icse2011.pdf icse2011-pre.pdf
	xelatex icse2011
	xelatex icse2011
	bibtex icse2011
	xelatex icse2011
	xelatex icse2011
	mv icse2011.pdf icse2011-pre.pdf



icse2011.pdf: icse2011-pre.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -dDownsampleColorImages=false -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -sDEVICE=pdfwrite -sOutputFile=icse2011.pdf icse2011-pre.pdf

icse2011-pdflatex-safe.pdf: icse2011-pdflatex.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -dDownsampleColorImages=false -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -sDEVICE=pdfwrite -sOutputFile=icse2011-pdflatex-safe.pdf icse2011-pdflatex.pdf


icse2011-pdflatex.pdf: icse2011.tex icpc.bib
	pdflatex icse2011
	pdflatex icse2011
	bibtex icse2011
	pdflatex icse2011
	pdflatex icse2011
	mv icse2011.pdf icse2011-pdflatex.pdf

icse2011.ps: icse2011.dvi
	dvips -Pdownload35 icse2011.dvi -o icse2011.ps


icse2011.dvi: icse2011.tex icpc.bib
	latex icse2011
	latex icse2011
	bibtex icse2011
	latex icse2011
	latex icse2011


clean:
	rm -f icse2011.dvi icse2011.ps icse2011.pdf icse2011.aux ahindle-lda.pdf icse2011.bbl *.blg *.log *.aux *.map *.bbl icse2011-pre.pdf || echo lol



.SUFFIXES: .eps .pdf
.suffixes: .eps .pdf

.eps.pdf:
	epstopdf $<

