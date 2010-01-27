#make clean paper1.pdf
#FILE=indentation.paper1.`date +"%Y%m%d.%H%M%S.%h.%d.%Y"`.pdf
#cp paper1.pdf $FILE
#vex $FILE
FILEO=lda-paper.pdf
make clean $FILEO 
FILE=lda-paper.`date +"%Y%m%d.%H%M%S.%h.%d.%Y"`.pdf
cp $FILEO $FILE
vex $FILE
