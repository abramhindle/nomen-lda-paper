for file in everything `cat projects`
do
	for category in detail large STBD Swanson
	do
		echo perl arff-mapper.pl $file/weka.arff $file/$category.arff $category
	done
done
