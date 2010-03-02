arff-files: topics2arff.py names.py quality_map.py get_exps.py check_validity.py count_annotations.py
	python topics2arff.py

validity-report: check_validity.py get_exps.py info_theory.py quality_map.py
	python check_validity.py

weka:	arff-files
	bash run-weka-classifier-single-trials.sh
	sh weka-shrink.sh

graphs: count_annotations.py
	python count_annotations.py

boxplots: graphs boxplotit.pl 
	perl	boxplotit.pl output/*boxplot*.xml
	perl convert-plots.sh

noweka: arff-files validity-report graphs boxplots

categories: make_categories.py
	python make_categories.py

mulan:	Makefile.mulan
	make -fMakefile.mulan all
	
