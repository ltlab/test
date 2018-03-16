#!/bin/bash

COLOR_SH="$HOME/bin/color.sh"

CSCOPE_FIND_OPTIONS="-name '*.[cCsShHx]' -o -name '*.cpp' -o -name '*.cc' -o -name '*.hh' -o -name '*.hpp' -o -name '*.ld' -o -name '*.scl' -o -name '*.inc' -o -name '[mM]akefile' -o -name '*.mk' -o -name '*.min' -type f"

EXEC_DIR=`pwd`

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

EXCLUDE_DIR=".svn .git"$EXCLUDE_DIR

for dir in $EXCLUDE_DIR
do
	CSCOPE_EXCLUDE_OPT="! ( -type d -name "$dir" -prune ) "$CSCOPE_EXCLUDE_OPT
done

if [ "$1" = "-r" ] ; then
	echo -e $RED_BOLD"Removing CSCOPE FILES in "$BLUE_BOLD"`pwd`"$ENDCOLOR
	rm -f ./cscope.*
elif [ "$1"  = "-c" ] || [ "$1" = "-C" ] ; then
	if [ -e "./cscope.files" ] ; then
		echo -e $RED_BOLD"Removing CSCOPE FILES in "$BLUE_BOLD"`pwd`"$ENDCOLOR
		rm -f ./cscope.*
	fi
	echo -e $BLUE_BOLD"EXCLUDE_DIR:"$YELLOW" $EXCLUDE_DIR\n"$ENDCOLOR
	echo -e $BLUE_BOLD"Current directory: \n"$ENDCOLOR"`pwd`"
	#LISTING_PATH="$PWD"
	echo -e $CYAN_BOLD"Listing files... :\t"$YELLOW"`pwd`"$ENDCOLOR
	if [ ! -z $2 ]  ; then
		shift
		for i in $(seq 1 1 $#)
		do
			cd $EXEC_DIR
			if [ -e $1 ] ; then
				cd $1
				DIR=`pwd`
				LISTING_PATH=$LISTING_PATH" $DIR"
				echo -e "\t\t\t"$BLUE_BOLD"$1"$ENDCOLOR
			else
				echo -e $RED"Warning: "$ENDCOLOR"Path [ $1 ] is not found."
			fi
			shift
		done

	fi
	#echo -e "find $LISTING_PATH $CSCOPE_EXCLUDE_OPT $CSCOPE_FIND_OPTIONS"

	cd $EXEC_DIR

	echo -e "find $LISTING_PATH $CSCOPE_EXCLUDE_OPT \( \
		-name '*.[cCsShHx]' -o \
		-name '*.cpp' -o -name '*.cc' -o -name '*.hh' -o -name '*.hpp' -o \
		-name '*.ld' -o -name '*.lds' -o -name '*.scl' -o \
		-name '*.inc' -o \
		-name '[mM]akefile' -o -name '*.mk' -o -name '*.min' -o \
		-name '*.java' -o -name '*.aidl' -o -name '*.xml' \
		\) -type f -print > cscope.files"
	echo -e "cscope -b $CSCOPE_OPTION -i cscope.files"

	find $LISTING_PATH $CSCOPE_EXCLUDE_OPT \( \
		-name '*.[cCsShHx]' -o \
		-name '*.cpp' -o -name '*.cc' -o -name '*.hh' -o -name '*.hpp' -o \
		-name '*.ld' -o -name '*.lds' -o -name '*.scl' -o \
		-name '*.inc' -o \
		-name '[mM]akefile' -o -name '*.mk' -o -name '*.min' -o \
		-name '*.java' -o -name '*.aidl' -o -name '*.xml' \
		\) -type f > cscope.files
		#\) -type f -exec echo \"{}\" \;	 > cscope.files
		#\) -type f -print > cscope.files
	#find $LISTING_PATH $CSCOPE_EXCLUDE_OPT \(		\
	#	-name '*.[cCsShHx]' -o \
	#	-name '*.cpp' -o -name '*.cc' -o -name '*.hh' -o -name '*.hpp' -o \
	#	-name '*.ld' -o -name '*.lds' -o -name '*.scl' -o \
	#	-name '*.inc' -o \
	#	-name '[mM]akefile' -o -name '*.mk' -o -name '*.min' \
	#	-name '*.java' -o -name '*.aidl' -o -name '*.xml' \
	#	\) -type f -exec echo \"{}\" \; > cscope.files

	#\) -type f -print > cscope.files
	#\) -type f -exec echo \"{}\" \;	 > cscope.files
	cscope -b $CSCOPE_OPTION -i cscope.files
fi

#	general
#	-q : generate inverted index for quick search

#cscope -b -i cscope.files

#	for kernelmode
#	-k : don't use /usr/include/
#	-q : Enable fast symbol lookup. cscope.po.out, cscope.in.out 

#cscope -b -q -k -i cscope.files
