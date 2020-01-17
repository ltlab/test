#!/bin/sh

echo "Installing TFTP Service..."

CONF_PATH=/root/config
CONF_BACKUP=/root/.config-backup

sudo apt install -q -y tftpd-hpa tftp-hpa

# chown root.tftp <tftpboot dir>
#sudo usermod -G tftp -a $USER
sudo mkdir -p /tftpboot
sudo chown tftp:tftp /tftpboot
sudo chmod g+w /tftpboot
sudo cp -a --backup=numbered /etc/default/tftpd-hpa $CONF_BACKUP
sudo cp -a $CONF_PATH/tftpd-hpa /etc/default/tftpd-hpa
sudo /etc/init.d/tftpd-hpa restart
