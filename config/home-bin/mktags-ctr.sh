#!/bin/bash

COLOR_SH="$HOME/bin/color.sh"

if [ -e $COLOR_SH ] ; then
	source $COLOR_SH
	#echo -e $RED_BOLD"Including Color.sh"$ENDCOLOR
fi

if [ -z $1 ] || [ "$1" = "-h" ] ; then
	echo "## Usage:  $0 [ -h | <cpu_name> ]"
	echo "           -h : Display this messages"
	echo "           <cpu_name> : ex) hi3521, hi3531, hi3532...."
	exit 0;
fi

CPU_NAME=$( echo $1 | tr A-Z a-z )

IS_UXXXX=$( svn info | grep uxxxx ; echo $? )

if [ "$IS_UXXXX" == "1" ] ; then
	IS_UXXXX="no"
else
	IS_UXXXX="yes"
fi

if [ "$CPU_NAME" = "hi3521" ] ; then
	CPU_DIR="Hi3521"
elif [ "$CPU_NAME" = "hi3531" ] ; then
	CPU_DIR="Hi3531"
elif [ "$CPU_NAME" = "hi3531a" ] ; then
	CPU_DIR="Hi3531a"
elif [ "$CPU_NAME" = "hi3532" ] ; then
	CPU_DIR="Hi3532"
elif [ "$CPU_NAME" = "hi3536" ] ; then
	CPU_DIR="Hi3536"
else
	CPU_DIR="Hi3531"
fi

SRC_DIR="../../$CPU_DIR \
	../../gSOAP \
	../../live555 \
	../../poco \
	../../COMMON \
	../../util"

if [ "$IS_UXXXX" = "yes" ] ; then
	SRC_DIR="$SRC_DIR ../../MediaServer"
else
	SRC_DIR="$SRC_DIR ../../IPC"
fi

#export EXCLUDE_DIR="nvt test"
export EXCLUDE_DIR="test"

MKCTAGS_CMD="mkctags.sh -c $SRC_DIR"
MKCSCOPE_CMD="mkcscope.sh -c $SRC_DIR"

echo -e $CYAN_BOLD"IS_UXXXX: $IS_UXXXX CPU_NAME: $CPU_NAME( $CPU_DIR ) @ "$YELLOW"`pwd`"$ENDCOLOR

mkctags.sh -r
echo -e $YELLOW_BOLD"CMD: $MKCTAGS_CMD"$ENDCOLOR
$MKCTAGS_CMD

mkcscope.sh -r
echo -e $YELLOW_BOLD"CMD: $MKCSCOPE_CMD"$ENDCOLOR
$MKCSCOPE_CMD
