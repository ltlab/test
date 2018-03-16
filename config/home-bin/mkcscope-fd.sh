#!/bin/bash

COLOR_SH="$HOME/bin/color.sh"

CSCOPE_FIND_OPTIONS=" \( -name '*.[cCsShH]' -o -name '*.cpp' -o -name '*.cc' -o -name '*.hh' -o -name '*.hpp' -o -name '*.ld' -o -name '*.scl' -o -name '*.inc' -o -name '[mM]akefile' -o -name '*.mk' -o -name '*.min' \) -type f -print > cscope.files"

if [ -e $COLOR_SH ] ; then
	source $COLOR_SH
#echo -e $RED_BOLD"Including Color.sh"$ENDCOLOR
fi

if [ -z $1 ] || [ "$1" = "-h" ] ; then
    echo "## Usage:  mkcscope.sh [ -c | -h | path... ]"
    echo "           for including other directory: mkcscope.sh -c <path>"
    echo "           -c : Create cscope files ex) mkcscope.sh -c or mkcscope.sh -c <path...>"
    echo "           -h : Display this messages"
    exit 0;
fi

if [ "$1" = "-r" ] ; then
	echo -e $RED_BOLD"Removing CSCOPE FILES in "$BLUE_BOLD"`pwd`"$ENDCOLOR
	rm -f ./cscope.*
elif [ "$1"  = "-c" ] || [ "$1" = "-C" ] ; then
	echo -e $BLUE_BOLD"Current directory: \n"$ENDCOLOR"`pwd`"
	LISTING_PATH="./"
	echo -e $CYAN_BOLD"Listing files... :\t"$YELLOW"`pwd`"$ENDCOLOR
	if [ ! -z $2 ]  ; then
		shift
		for i in $(seq 1 1 $#)
		do
			if [ -e $1 ] ; then
				LISTING_PATH=$LISTING_PATH" $1"
			echo -e "\t\t\t"$BLUE_BOLD"$1"$ENDCOLOR
			else
				echo -e $RED"Warning: "$ENDCOLOR"Path [ $1 ] is not found."
			fi
			shift
		done

	fi
	echo -e " find $LISTING_PATH $CSCOPE_FIND_OPTIONS"

	find $LISTING_PATH \
		! \( -type d -path './bsp/drivers' -prune \) \(		\
		-name '*.[cCsShHx]' -o \
		-name '*.cpp' -o -name '*.cc' -o -name '*.hh' -o -name '*.hpp' -o \
		-name '*.ld' -o -name '*.scl' -o \
		-name '*.inc' -o \
		-name '[mM]akefile' -o -name '*.mk' -o -name '*.min' \
		\) -type f -print > cscope.files
#\) -type f -exec echo \"{}\" \;	 > cscope.files
	cscope -b -i cscope.files
fi

#	general
#	-q : generate inverted index for quick search

#cscope -b -i cscope.files

#	for kernelmode
#	-k : don't use /usr/include/

#cscope -b -q -k -i cscope.files
