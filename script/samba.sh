#!/bin/sh

CONF_PATH=/root/config
CONF_BACKUP=/root/.config-backup

echo "Installing Samba Service..."

sudo apt install ${APT_CACHE_OPTION} -y -qq samba
#sudo smbpasswd -a jyhuh
#sudo vi /etc/samba/smb.conf
sudo cp -a --backup=numbered /etc/samba/smb.conf $CONF_BACKUP
sudo cp -a $CONF_PATH/smb.conf /etc/samba/smb.conf
sudo /etc/init.d/smbd restart
#(echo vagrant; echo vagrant) | sudo smbpasswd -s -a vagrant
