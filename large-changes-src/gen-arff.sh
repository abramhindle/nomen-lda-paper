for file in boost egroupware enlightenment firebird samba springframework
do
cd $file
	perl ../convert-abez-style-to-postgresql-style.pl markup_report markup_report.orig > readytoarff
	perl ../TextCount.pl $file readytoarff > $file.arff
	perl ../TextCount.pl $file readytoarff > weka.arff
cd ..
done
cd evolution 
	perl conv.pl evolution.annotated > readytoarff
	perl ../TextCount.pl evolution readytoarff > evolution.arff
	perl ../TextCount.pl evolution readytoarff > weka.arff
cd ..
cd postgresql
	ln -sf postgresql.report readytoarff
	perl ../TextCount.pl postgresql readytoarff > postgresql.arff
	perl ../TextCount.pl postgresql readytoarff > weka.arff
cd ..
cd mysql-5_0
	perl mysqlreader.pl sampled.mrs > markup_report.orig
	ln -sf sampled.mrs.annotated markup_report
	perl ../convert-abez-style-to-postgresql-style.pl markup_report markup_report.orig > readytoarff
	perl ../TextCount.pl mysql-5_0 readytoarff > mysql-5_0.arff
	perl ../TextCount.pl mysql-5_0 readytoarff > weka.arff
cd ..

