#!/bin/bash

SRC_DISK="nvme0n1"
DISK_PART=$SRC_DISK"p6"
DISK_PATH="/dev/$DISK_PART"
MOUNT_POINT="/home/jay/work"
SIZE=2048

sudo rapiddisk --attach $SIZE

sudo rapiddisk --cache-map rd0 $DISK_PATH
sudo mount /dev/mapper/rc-wt_$DISK_PART $MOUNT_POINT

sudo rapiddisk --list

sudo echo "2048" | sudo tee /sys/block/$SRC_DISK/queue/max_sectors_kb 2>&1	# 1280
sudo echo "1024" | sudo tee /sys/block/$SRC_DISK/queue/nr_requests 2>&1		# 128
sudo echo "1024" | sudo tee /sys/block/$SRC_DISK/queue/read_ahead_kb 2>&1	# 128
sudo echo "128" | sudo tee /sys/block/$SRC_DISK/device/queue_depth 2>&1		# 64

if [[ -z "$(grep CCACHE_DIR ~/.bashrc)" ]] ; then
	echo "#export CCACHE_DIR="
fi
