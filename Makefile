IMAGES=
default: view

view: ahindle-lda.pdf
	xpdf $<

SUBMISSION: ahindle-lda.pdf

ahindle-lda.pdf: lda-paper.pdf
	cp lda-paper.pdf ahindle-lda.pdf

lda-paper-pre.pdf: lda-paper.tex lda-paper.bib
	pdflatex lda-paper
	pdflatex lda-paper
	bibtex lda-paper
	pdflatex lda-paper
	pdflatex lda-paper
	mv lda-paper.pdf lda-paper-pre.pdf

lda-paper.pdf: lda-paper-pre.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -dDownsampleColorImages=false -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -sDEVICE=pdfwrite -sOutputFile=lda-paper.pdf lda-paper-pre.pdf


lda-paper.ps: lda-paper.dvi
	dvips -Pdownload35 lda-paper.dvi -o lda-paper.ps


lda-paper.dvi: lda-paper.tex lda-paper.bib
	latex lda-paper
	latex lda-paper
	bibtex lda-paper
	latex lda-paper
	latex lda-paper


clean:
	rm -f lda-paper-pre.pdf lda-paper.dvi lda-paper.ps lda-paper.pdf lda-paper.aux ahindle-lda.pdf lda-paper.bbl || echo lol



.SUFFIXES: .eps .pdf
.suffixes: .eps .pdf

.eps.pdf:
	epstopdf $<

