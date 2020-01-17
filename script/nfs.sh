#!/bin/sh

echo "Installing NFS Service..."

CONF_PATH=/root/config
CONF_BACKUP=/root/.config-backup

sudo apt install -q -y nfs-kernel-server
sudo cp -a --backup=numbered /etc/exports $CONF_BACKUP
#sudo cp -a $CONF_PATH/exports /etc/exports
sudo mkdir -p /nfs
sudo groupadd -g 2000 nfs
#sudo useradd nfs -u 2000 -U
sudo chown root:nfs /nfs
sudo chmod g+w /nfs
sudo /etc/init.d/nfs-kernel-server restart
