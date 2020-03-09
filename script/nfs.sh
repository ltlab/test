#!/bin/sh

echo "Installing NFS Service..."

APT="apt-get"

if [[ -z "${CI}" ]] ; then
	APT="apt"
fi

CONF_PATH=/root/config
CONF_BACKUP=/root/.config-backup

sudo ${APT} ${APT_CACHE_OPTION} install -y -qq nfs-kernel-server
sudo cp -a --backup=numbered /etc/exports $CONF_BACKUP
#sudo cp -a $CONF_PATH/exports /etc/exports
sudo mkdir -p /nfs
sudo groupadd -g 2000 nfs
#sudo useradd nfs -u 2000 -U
sudo chown root:nfs /nfs
# Set group permission for Write and setgid.
sudo chmod g+ws /nfs
sudo /etc/init.d/nfs-kernel-server restart
