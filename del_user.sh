#!/bin/bash

WSL=`uname -v | grep Microsoft`

set -e
#set -x	#	debug

USER_ID=$1
USER_HOME=/home/$USER_ID

if [[ -z "$1" ]] ; then
	echo "Usage: $0 [user]"
	exit 0
fi

if [[ -e "/nfs/$USER_ID" ]] ; then
	echo "Delete link for NFS user $USER_ID"
	# use for user's NFS directory: tailing TAB
	sudo sed -i "/$USER_ID\	/d" /etc/exports
	sudo rm /nfs/$USER_ID
	if [[ -z "$CI" ]] ; then
		sudo systemctl restart nfs-kernel-server
	else
		sudo /etc/init.d/nfs-kernel-server restart
	fi
fi

echo "Delete user $USER_ID and home"
sudo userdel -r $USER_ID

if [[ ! -z "$CI" ]] ; then
	service --status-all
	sudo service smbd status
	sudo service vsftpd status
	sudo service tftpd-hpa status
	#sudo service nfs-kernel-server status
	cat /etc/exports
	sudo exportfs
fi
