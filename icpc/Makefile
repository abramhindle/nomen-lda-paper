IMAGES=
default: view

view: icpc2010.pdf
	xpdf $<

icpc2010-pre.pdf: icpc2010.tex icpc.bib
	#	pdflatex icpc2010
	#pdflatex icpc2010
	#bibtex icpc2010
	#pdflatex icpc2010
	#pdflatex icpc2010
	#mv icpc2010.pdf icpc2010-pre.pdf
	xelatex icpc2010
	xelatex icpc2010
	bibtex icpc2010
	xelatex icpc2010
	xelatex icpc2010
	mv icpc2010.pdf icpc2010-pre.pdf



icpc2010.pdf: icpc2010-pre.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -dDownsampleColorImages=false -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -sDEVICE=pdfwrite -sOutputFile=icpc2010.pdf icpc2010-pre.pdf

icpc2010-pdflatex-safe.pdf: icpc2010-pdflatex.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -dDownsampleColorImages=false -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -sDEVICE=pdfwrite -sOutputFile=icpc2010-pdflatex-safe.pdf icpc2010-pdflatex.pdf


icpc2010-pdflatex.pdf: icpc2010.tex icpc.bib
	pdflatex icpc2010
	pdflatex icpc2010
	bibtex icpc2010
	pdflatex icpc2010
	pdflatex icpc2010
	mv icpc2010.pdf icpc2010-pdflatex.pdf

icpc2010.ps: icpc2010.dvi
	dvips -Pdownload35 icpc2010.dvi -o icpc2010.ps


icpc2010.dvi: icpc2010.tex icpc.bib
	latex icpc2010
	latex icpc2010
	bibtex icpc2010
	latex icpc2010
	latex icpc2010


clean:
	rm -f icpc2010.dvi icpc2010.ps icpc2010.pdf icpc2010.aux ahindle-lda.pdf icpc2010.bbl *.blg *.log *.aux *.map *.bbl icpc2010-pre.pdf || echo lol



.SUFFIXES: .eps .pdf
.suffixes: .eps .pdf

.eps.pdf:
	epstopdf $<

