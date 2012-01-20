IMAGES=
default: view

view: ese.pdf
	xpdf $<

#ese.ps: ese.tex
#	latex ese
#	latex ese
#	bibtex ese
#	latex ese
#	latex ese
#	dvips ese.dvi

ese-pre.pdf: ese.tex 
	#	pdflatex ese
	#pdflatex ese
	#bibtex ese
	#pdflatex ese
	#pdflatex ese
	#mv ese.pdf ese-pre.pdf
	xelatex ese
	xelatex ese
	bibtex ese
	xelatex ese
	xelatex ese
	mv ese.pdf ese-pre.pdf



ese.pdf: ese-pre.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -dDownsampleColorImages=false -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -sDEVICE=pdfwrite -sOutputFile=ese.pdf ese-pre.pdf

ese-pdflatex-safe.pdf: ese-pdflatex.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -dDownsampleColorImages=false -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -sDEVICE=pdfwrite -sOutputFile=ese-pdflatex-safe.pdf ese-pdflatex.pdf


ese-pdflatex.pdf: ese.tex 
	pdflatex ese
	pdflatex ese
	bibtex ese
	pdflatex ese
	pdflatex ese
	mv ese.pdf ese-pdflatex.pdf

ese.ps: ese.dvi
	dvips -Pdownload35 ese.dvi -o ese.ps


ese.dvi: ese.tex 
	latex ese
	latex ese
	bibtex ese
	latex ese
	latex ese


clean:
	rm -f ese.dvi ese.ps ese.pdf ese.aux ahindle-lda.pdf ese.bbl *.blg *.log *.aux *.map *.bbl ese-pre.pdf || echo lol



.SUFFIXES: .eps .pdf
.suffixes: .eps .pdf

.eps.pdf:
	epstopdf $<

ese-major-response.pdf: ese-major-response.tex
	pdflatex ese-major-response
	pdflatex ese-major-response
ese-major-response.dvi: ese-major-response.tex
	latex ese-major-response
	latex ese-major-response
ese-major-response.ps: ese-major-response.dvi
	dvips -Pdownload35 ese-major-response.dvi -o ese-major-response.ps


hindle-ernst-ese.ps: ese.ps
	mv ese.ps hindle-ernst-ese.ps
