#!/bin/sh

echo "Installing TFTP Service..."

CONF_PATH=/root/config
CONF_BACKUP=/root/.config-backup

sudo apt ${APT_CACHE_OPTION} install -y -qq tftpd-hpa tftp-hpa

# chown root.tftp <tftpboot dir>
#sudo usermod -G tftp -a $USER
sudo mkdir -p /tftpboot
sudo chown root:tftp /tftpboot
# Set group permission for Write and setgid.
sudo chmod g+ws /tftpboot
sudo cp -a --backup=numbered /etc/default/tftpd-hpa $CONF_BACKUP
sudo cp -a $CONF_PATH/tftpd-hpa /etc/default/tftpd-hpa
sudo /etc/init.d/tftpd-hpa restart
