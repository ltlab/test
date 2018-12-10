#!/bin/sh

WSL=`uname -v | grep Microsoft`

set -e
#set -x	#	debug

USER_ID=$1
USER_HOME=/home/$USER_ID

sudo userdel -r $USER_ID

sudo rm -f /nfs/$USER_ID

# remove /etc/exports
