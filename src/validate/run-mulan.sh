#java -cp mulan-1.0.1.jar;weka-3.7.0.jar mulan.examples.TrainTestExperiment -path
#java -cp mulan-1.0.1.jar:weka-36.jar mulan.examples.CrossValidationExperiment -path output/ -filestem $1 | tee output/$1.mulan.out
#java -cp mulan-1.0.1.jar:weka-3-6-2.jar mulan.examples.CrossValidationExperiment -path output/ -filestem $1 | tee output/$1.mulan.out
javac -cp mulan-1.0.1.jar:weka-3-7-0.jar:. CrossValidationExperiment.java 
java -cp mulan-1.0.1.jar:weka-3-7-0.jar:. CrossValidationExperiment -path output/ -filestem $1 | tee output/$1.mulan.out
