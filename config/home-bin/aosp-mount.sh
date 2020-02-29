#!/bin/bash

DEV_AOSP="/dev/nvme0n2p1"
DEV_OUT="/dev/nvme0n3p1"
DEV_CCACHE="/dev/nvme0n3p2"

MOUNT_POINT="/home/jay/home-cached"

if [[ ! -z $1 ]] ; then
	MOUNT_POINT=$1
fi

sudo mount ${DEV_AOSP} ${MOUNT_POINT}
sudo mount ${DEV_OUT} $HOME/out
#sudo mount ${DEV_CCACHE} $HOME/out/.ccache

if [[ ! -e "$HOME/out/.mounted" ]] ; then
	touch /home/jay/out/.mounted
fi
