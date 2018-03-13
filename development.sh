#!/bin/sh

#set -e
#set -x	#	debug

CONF_PATH=/root/config
CONF_BACKUP=/root/config-backup
LOCAL_ADMIN_PATH=~/bin/admin
LOCAL_CONF_PATH=$LOCAL_ADMIN_PATH/config

echo "Installing System Services..."

if [ -z "`sudo > /dev/null 2>&1`" ] ; then
	apt-get update -y > /dev/null 2>&1
	apt-get install -y sudo
else
	sudo apt-get update -y > /dev/null 2>&1
fi

if [ ! -e "$CONF_PATH" ] ; then
	if [ ! -d "$LOCAL_ADMIN_PATH" ] ; then
		echo "WARN: $LOCAL_CONF_PATH and $CONF_PATH NOT exist..."
		./cp_to_admin.sh
		#exit 1
	fi
	sudo cp -a $LOCAL_CONF_PATH $CONF_PATH
fi

if [ ! -e "$CONF_BACKUP" ] ; then
	sudo mkdir -p $CONF_BACKUP
fi

# for Development
#sudo apt-get install -y powerline
sudo apt-get install -y vim ctags cscope
sudo apt-get install -y gitk
sudo apt-get install -y make

# APM
sudo apt-get install -y apache2
sudo apt-get install -y mysql-server mysql-client
sudo apt-get install -y php libapache2-mod-php php-xml php-gd php-mysql

# SSH
sudo apt-get install -q -y openssh-server

# Samba
sudo apt-get install -q -y samba
#sudo smbpasswd -a jyhuh
#sudo vi /etc/samba/smb.conf
sudo cp -a /etc/samba/smb.conf $CONF_BACKUP
sudo cp -a $CONF_PATH/smb.conf /etc/samba/smb.conf
sudo /etc/init.d/smbd restart
#(echo vagrant; echo vagrant) | sudo smbpasswd -s -a vagrant

# FTP / TFTP
sudo apt-get install -q -y vsftpd
sudo apt-get install -q -y tftpd-hpa tftp-hpa

# NFS
sudo apt-get install -q -y nfs-kernel-server
sudo cp -a /etc/exports $CONF_BACKUP
sudo cp -a $CONF_PATH/exports /etc/exports
mkdir -p /nfs
#sudo groupadd nfs
sudo useradd nfs -u 2000 -U
sudo chown nfs:nfs /nfs
sudo chmod g+w /nfs
sudo /etc/init.d/nfs-kernel-server restart

# VCS
sudo apt-get install -q -y subversion git-core

sudo cp -a /etc/vsftpd.conf $CONF_BACKUP
sudo cp -a $CONF_PATH/vsftpd.conf /etc/vsftpd.conf
sudo touch /etc/vsftpd.chroot_list
sudo /etc/init.d/vsftpd restart

# Docker
sudo apt-get install -y docker.io
#sudo usermod -G docker -a $USER

# chown root.tftp <tftpboot dir>
#sudo usermod -G tftp -a $USER
sudo mkdir -p /tftpboot
sudo chown tftp:tftp /tftpboot
sudo chmod g+w /tftpboot
sudo cp -a /etc/default/tftpd-hpa $CONF_BACKUP
sudo cp -a $CONF_PATH/tftpd-hpa /etc/default/tftpd-hpa
sudo /etc/init.d/tftpd-hpa restart

#exit 0

echo "Installing Development Tools for gcc..."

# for Development
sudo apt-get install -y build-essential

sudo apt-get install -y gcc-multilib g++-multilib

# for compiling kernel( menuconfig )
sudo apt-get install -y ncurses-dev libssl-dev

# Remote Desktop
#sudo apt-get install -y xrdp
#sudo apt-get install -y mate-core mate-desktop-environment mate-notification-daemon
#echo mate-session>~/.xsession
#sudo /etc/init.d/xrdp restart

#sudo smbpasswd -a $USER

#apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
