#!/bin/sh

RAMDISK_IMG="$1"

WORK_RAMDISK_IMG="$RAMDISK_IMG.work"
RAMDISK="$WORK_RAMDISK_IMG"
RAMDISK_GZ="$RAMDISK.gz"
RAMDISK_DIR="${RAMDISK}_dir"

if [ -z $1 ] ; then
	echo -e "USAGE: $0 [ramdisk.img]"
	exit -1
fi

if [ ! -e $RAMDISK_IMG ] ; then
	echo -e "$RAMDISK_IMG was NOT found!!!!"
	exit -1
fi

echo "dd if=$RAMDISK_IMG of=$RAMDISK_GZ skip=64 bs=1"
dd if=$RAMDISK_IMG of=$RAMDISK_GZ skip=64 bs=1

gunzip -v $RAMDISK_GZ

mkdir -p $RAMDISK_DIR

sudo mount -t ext2 -o loop $RAMDISK $RAMDISK_DIR

