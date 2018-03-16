#!/bin/bash

COLOR_SH="$HOME/bin/color.sh"

KERNEL_HEADER_DIR=/usr/src/linux-headers-`uname -r`
KERNEL_SOURCE_DIR=/usr/src/linux-source-`uname -r|sed "s/-[0-9]*[a-z]*//g"`
LINUX_INCLUDE_DIR=/usr/include
EXEC_DIR=`pwd`

# langmap: move into ~/.ctags
#CTAGS_OPT="--langmap=sh:+.inc,asm:+.lds,asm:+.scl,make:+.min"
CTAGS_OPT=$CTAGS_OPT" --links=no"
CTAGS_OPT=$CTAGS_OPT" --c++-kinds=+p --fields=+iaS --extra=+q"
CTAGS_OPT=$CTAGS_OPT" --exclude=CVS \
	--exclude=.svn \
	--exclude=*.o \
	--exclude=*.d \
	--exclude=*.bak"
CTAGS_OPT=$CTAGS_OPT" -R"

if [ -e $COLOR_SH ] ; then
	source $COLOR_SH
	#echo -e $RED_BOLD"Including Color.sh"$ENDCOLOR
fi

#for arg in $*
#do
#	echo $arg
#done

#for index in $(seq 1 1 $#)
#do
#	echo $index: $1
#	shift
#done

#if [ -z $1 ] || [ -z $2 ] || [ "$1" = "-h" ] ; then
if [ -z $1 ] || [ "$1" = "-h" ] ; then
	echo "## Usage:  mkctags.sh [ -c | -C | -r | -h ] path "
	echo "           for other directory: mkctags.sh -c <path>"
	echo "           -c : Create tags file ex) mkctags.sh -c ./ or mkctags.sh -c <path>"
	echo "           -C : Create tags file with kernel source directory ex) mkctags.sh -C or mkctags.sh -c <path>"
	echo "           -r : Remove tags file ex) mkctags.sh -r or mkctags.sh -r <path>"
	echo "           -h : Display this messages"
	exit 0;
fi

for dir in $EXCLUDE_DIR
do
	CTAGS_OPT=$CTAGS_OPT" --exclude=$dir"
done

if [ "$1" = "-r" ] ; then
	echo -e $RED_BOLD"Removing CTAGS in "$BLUE_BOLD"`pwd`"$ENDCOLOR
	rm -f ./tags
	shift
	for i in $(seq 1 1 $#)
	do
		if [ -e $1 ] ; then
			echo -e $RED_BOLD"Removing CTAGS in "$BLUE_BOLD"$1\n"$ENDCOLOR
			rm -f $1/tags
		else
			echo -e $RED"Warning: "$ENDCOLOR"Path [ $1 ] is not found."
		fi
		shift
	done
elif [ "$1"  = "-c" ] || [ "$1" = "-C" ] ; then
	echo -e $CYAN_BOLD"CTAGS options: \n"$ENDCOLOR"$CTAGS_OPT\n"
	echo -e $BLUE_BOLD"EXCLUDE_DIR:"$YELLOW" $EXCLUDE_DIR\n"$ENDCOLOR
	echo -e $BLUE_BOLD"Current directory: \n"$ENDCOLOR"`pwd`"

	if [ "$1" = "-C" ] ; then
		echo -e ""
		if [ -e $KERNEL_HEADER_DIR ] ; then
			cd $KERNEL_HEADER_DIR
			echo -e "Creating CTAGS in "$YELLOW"`pwd`"$ENDCOLOR
			ctags $CTAGS_OPT
		fi

		if [ -e $KERNEL_SOURCE_DIR ] ; then
			cd $KERNEL_SOURCE_DIR
			echo -e "Creating CTAGS in "$YELLOW"`pwd`"$ENDCOLOR
			ctags $CTAGS_OPT
		fi

		if [ -e $LINUX_INCLUDE_DIR ] ; then
			cd $LINUX_INCLUDE_DIR
			echo -e "Creating CTAGS in "$YELLOW"`pwd`"$ENDCOLOR
			ctags $CTAGS_OPT
		fi
	fi
	cd $EXEC_DIR
	#ctags -R ./
	echo -e "\nSTART Creating CTAGS in "$RED_BOLD"`pwd`"$ENDCOLOR
	#ctags $CTAGS_OPT
	shift

	for i in $(seq 1 1 $#)
	do
		if [ -e $1 ] ; then
			#cd $1
			echo -e "Creating CTAGS in "$BLUE_BOLD"$1"$ENDCOLOR
			#ctags -R ./
			#sudo ctags $CTAGS_OPT
			cd $1
			DIR=`pwd`
			cd $EXEC_DIR
			ctags $CTAGS_OPT --append=yes $DIR
			echo "ctags $CTAGS_OPT --append=yes $DIR"
		else
			echo -e $RED"Warning: "$ENDCOLOR"Path [ $1 ] is not found."
		fi
		shift
	done
	echo -e "\nCreating CTAGS Completed in "$RED_BOLD"`pwd`"$ENDCOLOR
fi
