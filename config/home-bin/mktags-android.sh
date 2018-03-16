#!/bin/bash

COLOR_SH="$HOME/bin/color.sh"

if [ -e $COLOR_SH ] ; then
	source $COLOR_SH
	#echo -e $RED_BOLD"Including Color.sh"$ENDCOLOR
fi

#if [ -z $1 ] || [ "$1" = "-h" ] ; then
if [ "$1" = "-h" ] ; then
	echo "## Usage:  $0 [ -h | <android_ref> ]"
	echo "           -h : Display this messages"
	echo "           <android_ref> : ex) aosp, nexell, friendlyarm...."
	exit 0;
fi

ANDROID_REF=$( echo $1 | tr A-Z a-z )

SRC_DIR="./art \
	./bionic \
	./bootable \
	./build \
	./cts \
	./dalvik \
	./development \
	./device \
	./frameworks \
	./hardware \
	./libcore \
	./libnativehelper \
	./packages \
	./pdk \
	./system \
	./tools"

export EXCLUDE_DIR=".repo \
	abi \
	compatibility \
	developers \
	docs \
	external \
	kernel \
	ndk \
	platform_testing \
	prebuilts \
	sdk \
	test \
	toolchain \
	out \
	result \
	*x86* \
	*mips* \
	*qemu* \
	*.js \
	*.pyx"

if [ "$ANDROID_REF" = "aosp" ] ; then
	ANDROID_REF="AOSP"
elif [ "$ANDROID_REF" = "nexell" ] ; then
	ANDROID_REF="Nexell"
elif [ "$ANDROID_REF" = "friendlyarm" ] ; then
	ANDROID_REF="FriendlyARM"
else
	ANDROID_REF="Nexell"
fi

# SRC and EXCLUDE_DIR
if [ "$ANDROID_REF" = "FriendlyARM" ] ; then
	SRC_DIR=$SRC_DIR" ./vendor"
	#EXCLUDE_DIR=$EXCLUDE_DIR" ./abi \
	#	./ndk \"
	#	./docs"
fi

if [ "$ANDROID_REF" = "Nexell" ] ; then
	SRC_DIR=$SRC_DIR" ./vendor"
	EXCLUDE_DIR=$EXCLUDE_DIR" kernel u-boot 2ndboot bootloader"
fi

export CSCOPE_OPTION="-q -k"

MKCTAGS_CMD="mkctags.sh -c $SRC_DIR"
MKCSCOPE_CMD="mkcscope.sh -c $SRC_DIR"

echo -e $CYAN_BOLD"ANDROID_REF: $ANDROID_REF @ "$YELLOW"`pwd`"$ENDCOLOR

mkctags.sh -r
echo -e $YELLOW_BOLD"CMD: $MKCTAGS_CMD"$ENDCOLOR
$MKCTAGS_CMD

mkcscope.sh -r
echo -e $YELLOW_BOLD"CMD: $MKCSCOPE_CMD"$ENDCOLOR
$MKCSCOPE_CMD
