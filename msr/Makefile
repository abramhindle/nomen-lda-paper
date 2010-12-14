IMAGES=
default: view

view: msr2011.pdf
	xpdf $<

msr2011-pre.pdf: msr2011.tex icpc.bib
	#	pdflatex msr2011
	#pdflatex msr2011
	#bibtex msr2011
	#pdflatex msr2011
	#pdflatex msr2011
	#mv msr2011.pdf msr2011-pre.pdf
	xelatex msr2011
	xelatex msr2011
	bibtex msr2011
	xelatex msr2011
	xelatex msr2011
	mv msr2011.pdf msr2011-pre.pdf



msr2011.pdf: msr2011-pre.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -dDownsampleColorImages=false -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -sDEVICE=pdfwrite -sOutputFile=msr2011.pdf msr2011-pre.pdf

msr2011-pdflatex-safe.pdf: msr2011-pdflatex.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -dDownsampleColorImages=false -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -sDEVICE=pdfwrite -sOutputFile=msr2011-pdflatex-safe.pdf msr2011-pdflatex.pdf


msr2011-pdflatex.pdf: msr2011.tex icpc.bib
	pdflatex msr2011
	pdflatex msr2011
	bibtex msr2011
	pdflatex msr2011
	pdflatex msr2011
	mv msr2011.pdf msr2011-pdflatex.pdf

msr2011.ps: msr2011.dvi
	dvips -Pdownload35 msr2011.dvi -o msr2011.ps


msr2011.dvi: msr2011.tex icpc.bib
	latex msr2011
	latex msr2011
	bibtex msr2011
	latex msr2011
	latex msr2011


clean:
	rm -f msr2011.dvi msr2011.ps msr2011.pdf msr2011.aux ahindle-lda.pdf msr2011.bbl *.blg *.log *.aux *.map *.bbl msr2011-pre.pdf || echo lol



.SUFFIXES: .eps .pdf
.suffixes: .eps .pdf

.eps.pdf:
	epstopdf $<

