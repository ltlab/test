#!/bin/sh

CONF_PATH=/root/config
CONF_BACKUP=/root/.config-backup

echo "Installing Base Service..."

# SSH
sudo apt install -q -y openssh-server
sudo cp -a --backup=numbered /etc/ssh/sshd_config $CONF_BACKUP
sudo cp -a $CONF_PATH/sshd_config /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo apt install -q -y make
sudo apt install -q -y git git-review

sudo apt install -q -y vim ctags cscope
sudo apt install -q -y silversearcher-ag ack-grep

# Resource Monitoring
sudo apt install -q -y tmux sysstat

# Powerline
sudo apt install -y powerline fonts-powerline
