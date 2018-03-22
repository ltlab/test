#!/bin/sh

DST_PATH=$1
SIZE=1048576	#	1 MB

if [ ! -d $DST_PATH ] ; then
	mkdir -p $DST_PATH
fi

echo "DST: $DST_PATH"

#while [ : ]
for i in $( seq 0 899 )
do
	echo -e "dd if=/dev/zero of=$DST_PATH/$i bs=$SIZE count=1024"
	dd if=/dev/zero of=$DST_PATH/$i bs=$SIZE count=1024
done

