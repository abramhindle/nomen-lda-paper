# vpath %.svg ./order
# vpath %.pdf ./order
# vpath %.svg ./rendered
# vpath %.pdf ./rendered
# vpath %.svg ./numbers
# vpath %.pdf ./numbers
# vpath %.svg ./numbered
# vpath %.pdf ./numbered
# 

N=$(shell sh number-of-slides.sh)
NUMBERTARGETS=$(shell sh number-targets.sh)
SLIDES=$(shell sh list-final-slides.sh)

#stop deleting the intermediate files!
.SECONDARY:

default:	presentation.pdf

rendered:
	mkdir rendered

rendered/%.pdf: order/%.svg rendered
	inkscape -w 1024 --export-pdf=$@ $<

rendered/%.pdf: order/%.pdf rendered
	cp $< $@

numbered:
	mkdir numbered


numbers:
	mkdir numbers

numbers/%.svg: number.svg numbers mknumberslide
	sh mknumberslide $@

numbers/%.pdf: numbers/%.svg numbers
	inkscape -w 1024 --export-pdf=$@ $<

# so build all the numbers first so no issue
numbered/%.pdf:	rendered/%.pdf	$(NUMBERTARGETS) numbered
	pdftk $< stamp numbers/$(shell sh slide-number-of.sh $<).pdf output $@

presentation.pdf: $(SLIDES)
	echo $(SLIDES)
	pdftk $(SLIDES) output $@
