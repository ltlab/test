#!/bin/sh

LOCAL_ADMIN_PATH=~/bin/admin
LOCAL_CONF_PATH=$LOCAL_ADMIN_PATH/config
CONF_BACKUP=/root/.config-backup

UDEV_NET_FILE=/etc/udev/rules.d/70-persistent-net.rules

if [ -z "`which sudo`" ] ; then
	apt-get update
	apt-get install -y sudo
fi

if [ ! -e "$CONF_BACKUP" ] ; then
	sudo mkdir -p $CONF_BACKUP
fi

if [ -z "`ifconfig -a | grep eth`" ] ; then
	sudo sed -i "s/CMDLINE_LINUX=\"\"/CMDLINE_LINUX=\"net.ifnames=0 biosname=0\"/" /etc/default/grub
	sudo update-grub2
	if [ -e "$UDEV_NET_FILE" ] ; then
		sudo mv $UDEV_NET_FILE $CONF_BACKUP
	fi
fi

if [ ! -d "$LOCAL_ADMIN_PATH" ] ; then
	sudo mkdir -p $LOCAL_ADMIN_PATH
	sudo cp -a ./config $LOCAL_CONF_PATH
	sudo cp -a ./system_conf/* $LOCAL_CONF_PATH
	sudo cp -a ./*.sh $LOCAL_ADMIN_PATH
	sudo chown -R root:root $LOCAL_ADMIN_PATH
	sudo chown $USER:$USER ~/bin
fi
