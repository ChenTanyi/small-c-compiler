# This script is used to do quick
# run for the project

if (($# < 4)); then
	echo Error! test.sh should be executed with more than 4 arguments
	exit 1
fi
for i in `ls $1`; do
	mkdir -p $2/$i
	mkdir -p $3/$i
	mkdir -p $4/$i
	for j in `ls $1/$i | grep "\.cpp"`; do
		filename=`basename $j .cpp`
		./scc $1/$i/$j $2/$i/$filename.s $3/$i/$filename.ir $4/$i/$filename.tree
	done
done