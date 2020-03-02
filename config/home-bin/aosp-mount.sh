#!/bin/bash

SRC_DISK="nvme0n2"
DISK_PART=$SRC_DISK"p1"
DISK_PATH="/dev/$DISK_PART"
SIZE=4096

DEV_AOSP="/dev/nvme0n2p1"
DEV_OUT="/dev/nvme0n3p1"
DEV_CCACHE="/dev/nvme0n3p2"

MOUNT_POINT="/home/jay/home-cached"

#sudo modprobe bcache

if [[ $(false) ]] ; then
	sudo rapiddisk --attach 4096
	sudo make-bcache -B /dev/nvme0n3p1 -C /dev/rd0 --block=4096 --bucket=2M --writeback --wipe-bcache
	#sudo make-bcache -C --block=4096 --bucket=2M --wipe-bcache --writeback /dev/rd0
	echo /dev/rd0 2>&1 | sudo tee  /sys/fs/bcache/register
	echo /dev/nvme0n3p1 2>&1 | sudo tee  /sys/fs/bcache/register
	sudo bcache-super-show /dev/rd0
	sudo bcache-super-show /dev/bcache0
	sudo bcache-super-show /dev/nvme0n3p1

#sudo make-bcache -B --block=4096 --bucket=2M --writeback --cset-uuid 8a30481d-23e3-4901-9387-e19c822ae099 /dev/nvme0n3p1
### Detach Device
#echo 1 | sudo tee  /sys/block/nvme0n3/nvme0n3p1/bcache/stop
#sudo wipefs -a /dev/nvme0n3p1
	exit 0
fi

sudo mount ${DEV_AOSP} ${MOUNT_POINT}
sudo mount ${DEV_OUT} $HOME/out
#sudo mount ${DEV_CCACHE} $HOME/out/.ccache

if [[ ! -e "${DEV_OUT}/.mounted" ]] ; then
	touch $HOME/out/.mounted
fi
