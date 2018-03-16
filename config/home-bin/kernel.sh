#!/bin/sh

#kernel.sh -o ~/nfs/kernel-obj/ -j8 -v -k nanopi3_core-qt_jyhuh_defconfig

if [ -z $1 ] || [ "$1" = "-h" ] ; then
	echo "## Usage:	$0 [ -k target | -a arch | -o output_dir | -j jobs | -v ]"
	echo "			kernel build sctipt"
	echo "			-k: Makefile target. ex) board_defconfig, menuconfig, uImage..."
	echo "			-v: verbose output"
	exit 0;
fi

while getopts ":a::k:i:o::j::v" opt ; do
	case $opt in
		a)
			ARCH=$OPTARG
			;;
		k)
			MAKE_TARGET=$OPTARG
			;;
		o)
			OUTPUT_DIR=$OPTARG
			OUTPUT_OPT="O="$OUTPUT_DIR
			;;
		j)
			JOBS="-j"$OPTARG
			;;
		v)
			VERBOSE="V=1"
			;;
		\?)
			echo "Invalid option: $OPTARG" >&2
			exit 0;
			;;
	esac
done

if [ "$MAKE_TARGET" = "tags" ] ; then
	MAKE_TARGET="tags cscope"
fi

if [ -z $ARCH ] ; then
	ARCH=arm
fi

#echo "ARCH=$ARCH make $MAKE_TARGET $OUTPUT_OPT $VERBOSE $JOBS"
make ARCH=$ARCH $MAKE_TARGET $OUTPUT_OPT $VERBOSE $JOBS

if [ -e $OUTPUT_DIR/tags ] ; then
	#echo "mv $OUTPUT_DIR/tags $OUTPUT_DIR/cscope* $PWD"
	mv $OUTPUT_DIR/tags $OUTPUT_DIR/cscope* $PWD
fi
