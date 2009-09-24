FILE = presentation
NFILE = notes
NAME = ahindle-lda-presentation
HEIGHT=22cm
HEIGHT=225mm
WIDTH=30cm
default: $(NAME).pdf

$(NAME).pdf: $(FILE).out.pdf
	cp $(FILE).out.pdf $(NAME).pdf

notes: $(NFILE).pdf 
notesview: $(NFILE).pdf 
	xpdf $(NFILE).pdf

$(NFILE).pdf: $(NFILE).out.pdf
	cp $(NFILE).out.pdf $(NFILE).pdf

edit: ${FILE}.tex
	gvim $<

view: ${FILE}.out.pdf 
	xpdf -z page ${FILE}.out.pdf

psview: ${FILE}.out.ps
	gv ${FILE}.out.ps

present: ${FILE}.out.pdf icsm2009-presentation-ahindle.pdf
	#xpdf -fullscreen -bg black ${FILE}.out.pdf
	#xpdf -fullscreen -bg black ${FILE}.out.pdf
	acroread icsm2009-presentation-ahindle.pdf

#		acroread ${FILE}.out.pdf	

acro: ${FILE}.out.pdf
	acroread $<

edit:
	gvim ${FILE}.tex

${FILE}.out.tex: parser.pl ${FILE}.tex header.tex
	perl parser.pl < ${FILE}.tex > ${FILE}.out.tex

${NFILE}.out.tex: 	notes1.out.tex notes.tex
	cp notes.tex $(NFILE).out.tex

notes1.out.tex: parser.pl notes1.tex 
	perl parser.pl < notes1.tex > notes1.out.tex



transitions: ${TRANSITIONSEPS}



${FILE}.out.pdf:	${FILE}.out.ps
	ps2pdf -dEmbedAllFonts=true $<

${NFILE}.out.pdf:	${NFILE}.out.ps
	ps2pdf -dEmbedAllFonts=true $<


#${FILE}.out.pdf:	${FILE}.out.tex 
#	pdflatex ${FILE}.out.tex
#	bibtex ${FILE}.out
#	pdflatex ${FILE}.out.tex
#	pdflatex ${FILE}.out.tex
${FILE}.out.ps:	${FILE}.out.dvi 
	dvips -T ${WIDTH},${HEIGHT} $< -o $@
#${FILE}.out.ps:	${FILE}.out.dvi 
#	dvips -T ${WIDTH},${HEIGHT} $< -o $@

${NFILE}.out.ps:	${NFILE}.out.dvi 
	dvips -T ${WIDTH},${HEIGHT} $< -o $@


#

$(FILE).out.dvi: $(FILE).out.tex ${TRANSITIONSEPS}
	latex $(FILE).out
#	bibtex $(FILE).out
	latex $(FILE).out
	latex $(FILE).out

$(NFILE).out.dvi: $(NFILE).out.tex ${TRANSITIONSEPS}
	latex $(NFILE).out
#	bibtex $(NFILE).out
	latex $(NFILE).out
	latex $(NFILE).out





$(FILE).s: $(FILE).dvi
	dvips -T ${WIDTH},${HEIGHT} -o $@ $<

$(NFILE).ps: $(NFILE).dvi
	dvips -T ${WIDTH},${HEIGHT} -o $@ $<


#$(FILE).ps: $(FILE).dvi
#	dvips -T ${WIDTH},${HEIGHT} -o $@ $<



$(FILE).pdf: $(FILE).ps
	ps2pdf $< $@



.SUFFIXES: .ps .pdf .eps .dia .svg .pdf .png .slides.pdf

.ps.pdf:
	ps2pdf $<

.svg.pdf:
	inkscape -w 1024 --export-pdf=$@ $<

.png.slides.pdf:
	convert $< -scale 1024x768 $@
	

.dia.eps:
	dia -n -t eps $<

.png.eps:
	convert $< $@
.jpg.eps:
	convert $< $@

clean:
	rm -f *.bbl *.aux
	rm -f ${FILE}.out.*
	rm -f ${FILE}.out.pdf 



slide01-dev-history.svg.pdf: 					slide01-dev-history.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide02-dev-history.svg.pdf:                                    slide02-dev-history.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide03-self-organize.svg.pdf:                                  slide03-self-organize.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide04-related-topic.svg.pdf:                                  slide04-related-topic.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide050-automateit.svg.pdf:                                    slide050-automateit.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide060-newspaper.svg.pdf:                                     slide060-newspaper.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide070-newspaper-sections.svg.pdf:                            slide070-newspaper-sections.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide080-sections-of-articles.svg.pdf:                          slide080-sections-of-articles.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide090-articles-without-sections.svg.pdf:                     slide090-articles-without-sections.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide100-read-or-automate.svg.pdf:                              slide100-read-or-automate.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide110-lda-first-example.svg.pdf:                             slide110-lda-first-example.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide120-document-word-distribution.svg.pdf:                    slide120-document-word-distribution.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide130-apply-lda.svg.pdf:                                     slide130-apply-lda.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide140-more-lda.svg.pdf:                                      slide140-more-lda.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide150-linear-combination.svg.pdf:                            slide150-linear-combination.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide160-topic-naming.svg.pdf:                                  slide160-topic-naming.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide170-previous.svg.pdf:                                      slide170-previous.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide170-relate-back-to-software-engineering.svg.pdf:           slide170-relate-back-to-software-engineering.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide190-sections-global.svg.pdf:                               slide190-sections-global.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide200-local-topics.svg.pdf:                                  slide200-local-topics.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide210-again-back-to-software.svg.pdf:                        slide210-again-back-to-software.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide215-RUP.svg.pdf:                                           slide215-RUP.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide217-global-and-local.svg.pdf:                              slide217-global-and-local.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide220-apply-sliding-window.svg.pdf:                          slide220-apply-sliding-window.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide230-topics-per-window.svg.pdf:                             slide230-topics-per-window.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide240-repeating-topics.svg.pdf:                              slide240-repeating-topics.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide250-grouping.svg.pdf:                                      slide250-grouping.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide260-similarity.svg.pdf:                                    slide260-similarity.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide270-lda-flow.svg.pdf:                                      slide270-lda-flow.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide280-dictionary.svg.pdf:                                    slide280-dictionary.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide290-mysql-manual-case-study.svg.pdf:                       slide290-mysql-manual-case-study.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide293-mysql-manual-case-study-plot.svg.pdf:                  slide293-mysql-manual-case-study-plot.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide295-mysql-manual-case-large.svg.pdf:                       slide295-mysql-manual-case-large.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide297-mysql-manual-case-small.svg.pdf:                       slide297-mysql-manual-case-small.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide300-month-diagram.svg.pdf:                                 slide300-month-diagram.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide310-maxdb7500-process.svg.pdf:                             slide310-maxdb7500-process.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide311-condensed-plot.svg.pdf:                                slide311-condensed-plot.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide312-condensed-plot-repeating-trends.svg.pdf:               slide312-condensed-plot-repeating-trends.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide313-condensed-plot-local-trends.svg.pdf:                   slide313-condensed-plot-local-trends.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide314-condensed-plot-gap.svg.pdf:                            slide314-condensed-plot-gap.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide330-observation-topic-naming.svg.pdf:                      slide330-observation-topic-naming.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide340-observations-local-topics.svg.pdf:                     slide340-observations-local-topics.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide350-observation-power-law.svg.pdf:                         slide350-observation-power-law.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide360-observation-power-law-implications.svg.pdf:            slide360-observation-power-law-implications.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide370-future-work-naming.svg.pdf:                            slide370-future-work-naming.svg
	inkscape -w 1024 --export-pdf=$@ $<
slide400-conclusions.svg.pdf:                                   slide400-conclusions.svg
	inkscape -w 1024 --export-pdf=$@ $<


SLIDES=slide02-dev-history.svg.pdf slide03-self-organize.svg.pdf slide04-related-topic.svg.pdf slide050-automateit.svg.pdf slide060-newspaper.svg.pdf slide070-newspaper-sections.svg.pdf slide080-sections-of-articles.svg.pdf slide090-articles-without-sections.svg.pdf slide100-read-or-automate.svg.pdf slide110-lda-first-example.svg.pdf slide120-document-word-distribution.svg.pdf slide130-apply-lda.svg.pdf slide140-more-lda.svg.pdf slide150-linear-combination.svg.pdf slide160-topic-naming.svg.pdf slide170-previous.svg.pdf slide170-relate-back-to-software-engineering.svg.pdf slide190-sections-global.svg.pdf slide200-local-topics.svg.pdf slide210-again-back-to-software.svg.pdf slide215-RUP.svg.pdf slide217-global-and-local.svg.pdf slide220-apply-sliding-window.svg.pdf slide230-topics-per-window.svg.pdf slide240-repeating-topics.svg.pdf slide250-grouping.svg.pdf slide260-similarity.svg.pdf slide270-lda-flow.svg.pdf slide280-dictionary.svg.pdf slide290-mysql-manual-case-study.svg.pdf slide293-mysql-manual-case-study-plot.svg.pdf slide295-mysql-manual-case-large.svg.pdf slide297-mysql-manual-case-small.svg.pdf slide300-month-diagram.svg.pdf slide310-maxdb7500-process.svg.pdf slide311-condensed-plot.svg.pdf slide312-condensed-plot-repeating-trends.svg.pdf slide313-condensed-plot-local-trends.svg.pdf slide314-condensed-plot-gap.svg.pdf slide330-observation-topic-naming.svg.pdf slide340-observations-local-topics.svg.pdf slide350-observation-power-law.svg.pdf slide360-observation-power-law-implications.svg.pdf slide370-future-work-naming.svg.pdf slide400-conclusions.svg.pdf month.png.slide.pdf time-smear-plot.png.slide.pdf fixed-time-smear-plot-cropped.png.slide.pdf class-smear-plot-crop-scaled.png.slide.pdf histogram-cropped-scaled.png.slide.pdf slide01-dev-history.svg.pdf

slides: $(SLIDES) icsm2009-presentation-ahindle.pdf

icsm2009-presentation-ahindle.pdf: $(SLIDES)
	sh -x compile-slides.sh
