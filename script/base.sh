#!/bin/sh

CONF_PATH=/root/config
CONF_BACKUP=/root/.config-backup

echo "Installing Base Service..."

sudo timedatectl set-timezone 'Asia/Seoul'
date

# SSH
sudo apt install -y -qq openssh-server
sudo cp -a --backup=numbered /etc/ssh/sshd_config $CONF_BACKUP
sudo cp -a $CONF_PATH/sshd_config /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo apt install -y -qq make
sudo apt install -y -qq git git-review
sudo apt install -y -qq gnupg

sudo apt install -y -qq vim ctags cscope
sudo apt install -y -qq silversearcher-ag ack-grep

# Resource Monitoring
sudo apt install -y -qq tmux sysstat

# Powerline
sudo apt install -y -qq powerline fonts-powerline

