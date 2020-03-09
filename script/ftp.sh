#!/bin/bash

APT="apt-get"

if [[ -z "${CI}" ]] ; then
	APT="apt"
fi

echo "Installing FTP Service..."

CONF_PATH=/root/config
CONF_BACKUP=/root/.config-backup

sudo ${APT} ${APT_CACHE_OPTION} install -y -qq vsftpd

# config for vsftpd
sudo cp -a --backup=numbered /etc/vsftpd.conf $CONF_BACKUP
sudo cp -a $CONF_PATH/vsftpd.conf /etc/vsftpd.conf
sudo touch /etc/vsftpd.chroot_list
sudo /etc/init.d/vsftpd restart
