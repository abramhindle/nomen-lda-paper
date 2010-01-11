
ALTARFFS=boost/dir.arff               enlightenment/dir.arff          samba/dir.arff boost/dir.detail.arff        enlightenment/dir.detail.arff   samba/dir.detail.arff boost/dir.large.arff         enlightenment/dir.large.arff    samba/dir.large.arff boost/dir.STBD.arff          enlightenment/dir.STBD.arff     samba/dir.STBD.arff boost/dir.Swanson.arff       enlightenment/dir.Swanson.arff  samba/dir.Swanson.arff egroupware/dir.arff          firebird/dir.arff               springframework/dir.arff egroupware/dir.detail.arff   firebird/dir.detail.arff        springframework/dir.detail.arff egroupware/dir.large.arff    firebird/dir.large.arff         springframework/dir.large.arff egroupware/dir.STBD.arff     firebird/dir.STBD.arff          springframework/dir.STBD.arff egroupware/dir.Swanson.arff  firebird/dir.Swanson.arff       springframework/dir.Swanson.arff 

all:

tables:
	perl mkmltables.pl	

reports:
	sh make_report.sh

weka:	$ALTARFFS
	sh run-exp.sh | make -j4 -f -  all

$ALTARFFS:
	sh mk-alt-arffs.sh
