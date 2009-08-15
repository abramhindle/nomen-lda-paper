PROGS  = testf lda_report
SOURCES = Lda_parser.hs test.hs

run:	Lda_report
	./Lda_report

imgtest: Lda_report
	./Lda_report 

test:	testf
	./testf

testf: test.hs
	$(HC_RULE)

Lda_report_driver:  Lda_report_driver.hs Lda_report.hs Lda_parser.hs Lda_layout.hs 
	$(HC_RULE)

Lda_relator:  Lda_relator.hs Lda_parser.hs Lda_layout.hs  EqClass.hs
	$(HC_RULE)


Ranked_driver: Ranked_driver.hs Ranked.hs Lda_report_driver.hs Lda_report.hs Lda_parser.hs Lda_layout.hs 
	$(HC_RULE)

#Lda_parser.o: Lda_parser.hs
#	$(HC_RULE)


all : $(PROGS)

GHCFLAGS=-O2 -fglasgow-exts -fasm -threaded
HC_RULE = $(HC) $(GHCFLAGS) --make $< -o $@ $(HCFLAGS)
HC_O_RULE = $(HC) $(GHCFLAGS) --make $< -c $@ $(HCFLAGS)


clean:
	rm -f $(SOURCES:.hs=.hi) $(SOURCES:.hs=.o) $(PROGS)

HC=/usr/local/bin/ghc
