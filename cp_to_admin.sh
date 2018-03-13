#!/bin/sh

LOCAL_ADMIN_PATH=~/bin/admin
LOCAL_CONF_PATH=$LOCAL_ADMIN_PATH/config

if [ -z "`which sudo > /dev/null 2>&1`" ] ; then
	apt-get update -y > /dev/null 2>&1
	apt-get install -y sudo
else
	sudo apt-get update -y > /dev/null 2>&1
fi

if [ ! -d "$LOCAL_ADMIN_PATH" ] ; then
	sudo mkdir -p $LOCAL_ADMIN_PATH
	sudo cp -av ./config $LOCAL_CONF_PATH
	sudo cp -av ./server_conf/* $LOCAL_CONF_PATH
	sudo cp -av ./*.sh $LOCAL_ADMIN_PATH
	sudo chown -R root:root $LOCAL_ADMIN_PATH
fi
