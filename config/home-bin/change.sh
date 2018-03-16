#!/bin/bash

ORIGINAL_TEXT="org"
REPLACE_TEXT="replace"

#for i in `find . -type f -name Makefile`
for i in `find . -type f` 
do
	#sed -e "s/e-ronix/"\&"/g" $i > $i.old
	sed -e "s/$ORIGINAL_TEXT/$REPLACE_TEXT/g" $i > $i.old
	echo -e "sed -e 's/$ORIGINAL_TEXT/$REPLACE_TEXT/g' $i > $i.old"
	echo -e "$i"
	mv $i.old $i
done
