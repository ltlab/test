#!/bin/sh

RAMDISK_IMG="$1"
RAMDISK_LABEL="$2"

if [ -z $1 ] ; then
	echo -e "USAGE: $0 [ramdisk.img] [label]"
	exit -1
fi

WORK_RAMDISK_IMG="$RAMDISK_IMG.work"
RAMDISK="$WORK_RAMDISK_IMG"
RAMDISK_GZ="$RAMDISK.gz"
RAMDISK_DIR="${RAMDISK}_dir"

sudo umount $RAMDISK_DIR

rmdir $RAMDISK_DIR

gzip $RAMDISK

#mv t_ramdisk.gz ramdisk_8.gz

#./mkimage -n 'ctrPro ramdisk' -A arm -O linux -T ramdisk -C gzip -a 0x80800000 -e 0x80800000 -d $RAMDISK_GZ $RAMDISK_IMG
echo -e "mkimage -n '$RAMDISK_LABEL' -A arm -O linux -T ramdisk -C gzip -a 0x80800000 -e 0x80800000 -d $RAMDISK_GZ $RAMDISK_IMG"
mkimage -n 'RAMDISK_LABEL' -A arm -O linux -T ramdisk -C gzip -a 0x80800000 -e 0x80800000 -d $RAMDISK_GZ $RAMDISK_IMG

rm -v $RAMDISK_GZ

