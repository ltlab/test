#!/bin/sh

ORIGINAL_TEXT="$1"
REPLACE_TEXT="$2"
DIR="$3"

if [ -z "$DIR" ] ; then
  echo "PATH not found"
  exit -1
fi

#for i in `find . -type f -name Makefile`
for i in `find $DIR -type f`
do
	#sed -e "s/e-ronix/"\&"/g" $i > $i.old
#	sed -e "s/$ORIGINAL_TEXT/$REPLACE_TEXT/g" $i > $i.old
#	echo -e "sed -e 's/$ORIGINAL_TEXT/$REPLACE_TEXT/g' $i > $i.old"
#	echo -e "$i"
#	mv $i.old $i
	sed -i "s/$ORIGINAL_TEXT/$REPLACE_TEXT/g" $i
done
