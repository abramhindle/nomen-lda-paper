IMAGES=
default: view

SUBMISSION: ahindle-lda.pdf

lda-paper-pre.pdf: lda-paper.tex lda-paper.bib
	pdflatex lda-paper
	pdflatex lda-paper
	bibtex lda-paper
	pdflatex lda-paper
	pdflatex lda-paper
	mv lda-paper.pdf lda-paper-pre.pdf

lda-paper.pdf: lda-paper-pre.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=lda-paper.pdf lda-paper-pre.pdf


lda-paper.ps: lda-paper.dvi
	dvips -Pdownload35 lda-paper.dvi -o lda-paper.ps


lda-paper.dvi: lda-paper.tex lda-paper.bib
	latex lda-paper
	latex lda-paper
	bibtex lda-paper
	latex lda-paper
	latex lda-paper


clean:
	rm -f lda-paper.dvi lda-paper.ps lda-paper.pdf lda-paper.aux lda-paper.bbl || echo lol



.SUFFIXES: .eps .pdf
.suffixes: .eps .pdf

.eps.pdf:
	epstopdf $<

