#java -cp mulan-1.0.1.jar;weka-3.7.0.jar mulan.examples.TrainTestExperiment -path
#java -cp mulan-1.0.1.jar:weka-36.jar mulan.examples.CrossValidationExperiment -path output/ -filestem $1 | tee output/$1.mulan.out
#java -cp mulan-1.0.1.jar:weka-3-6-2.jar mulan.examples.CrossValidationExperiment -path output/ -filestem $1 | tee output/$1.mulan.out
#CP=mulan-1.0.1.jar:weka-3-7-0.jar:. 
CP=mulan-1.3/mulan-1.3.0/mulan.jar:mulan-1.3/mulan-1.3.0/weka.jar:.
make -f Makefile.mulan CrossValidationExperiment.class
java -cp $CP CrossValidationExperiment -path output/ -filestem $1 | tee output/$1.mulan.out
