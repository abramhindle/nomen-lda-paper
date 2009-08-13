OCAMLC=ocamlopt.opt

run:
	WNSEARCHDIR

related.cmx: related.ml wordnet.cmx
	$(OCAMLC) -c related.ml
wordnet.cmx: wordnet.ml
	$(OCAMLC) -c wordnet.ml
demo:	demo.ml related.cmx wordnet.cmx
	$(OCAMLC) -o demo wordnet.cmx related.cmx demo.ml
related-words:	related-words.ml related.cmx wordnet.cmx
	$(OCAMLC) -o related-words wordnet.cmx related.cmx related-words.ml
