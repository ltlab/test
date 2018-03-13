#!/bin/sh

LOCAL_ADMIN_PATH=~/bin/admin
LOCAL_CONF_PATH=$LOCAL_ADMIN_PATH/config

if [ -z "`which sudo`" ] ; then
	apt-get update
	apt-get install -y sudo
fi

if [ -z `ifconfig -a | grep eth` ] ; then
	sudo sed -i "s/CMDLINE_LINUX=\"\"/CMDLINE_LINUX=\"net.ifnames=0 biosname=0\"/" /etc/default/grub
	sudo update-grub2
fi

if [ ! -d "$LOCAL_ADMIN_PATH" ] ; then
	sudo mkdir -p $LOCAL_ADMIN_PATH
	sudo cp -av ./config $LOCAL_CONF_PATH
	sudo cp -av ./system_conf/* $LOCAL_CONF_PATH
	sudo cp -av ./*.sh $LOCAL_ADMIN_PATH
	sudo chown -R root:root $LOCAL_ADMIN_PATH
	sudo chown $USER:$USER ~/bin
fi
