#!/bin/bash

COLOR_SH="$HOME/bin/color.sh"

if [ -e $COLOR_SH ] ; then
	source $COLOR_SH
#echo -e $RED_BOLD"Including Color.sh"$ENDCOLOR
fi

if [ -z $1 ] || [ "$1" = "-h" ] ; then
    echo "## Usage:  $0 [ -h | <modelname> ]"
    echo "           -h : Display this messages"
	echo "           <modelname> : ex) ed04p, fd02, fd16x, ndv"
    exit 0;
fi

MODEL=`echo $1 | tr A-Z a-z`

MKCTAGS_CMD="mkctags.sh -c"
MKCSCOPE_CMD="mkcscope.sh -c"

case $MODEL in
	ed04p | ed08p | ed16p | fd02 | fd04 | fd04a | fd04x | fd08 | fd08x | fd16 |fd16x )
		echo -e $CYAN_BOLD"Model: $MODEL \t"$YELLOW"`pwd`"$ENDCOLOR

		MKCTAGS_CMD="mkctags-fd.sh -c ./bsp/drivers/$MODEL"
		MKCSCOPE_CMD="mkcscope-fd.sh -c ./bsp/drivers/$MODEL"
        ;;
esac

mkctags.sh -r
echo -e $YELLOW_BOLD"CMD: $MKCTAGS_CMD"$ENDCOLOR
$MKCTAGS_CMD

mkcscope.sh -r
echo -e $YELLOW_BOLD"CMD: $MKCSCOPE_CMD"$ENDCOLOR
$MKCSCOPE_CMD
