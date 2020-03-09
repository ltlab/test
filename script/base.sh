#!/bin/sh

CONF_PATH=/root/config
CONF_BACKUP=/root/.config-backup

echo "Installing Base Service..."

sudo timedatectl set-timezone 'Asia/Seoul'
date

# SSH
sudo apt install ${APT_CACHE_OPTION} -y -qq openssh-server
sudo cp -a --backup=numbered /etc/ssh/sshd_config $CONF_BACKUP
sudo cp -a $CONF_PATH/sshd_config /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo apt install ${APT_CACHE_OPTION} -y -qq make curl
sudo apt install ${APT_CACHE_OPTION} -y -qq git git-review
sudo apt install ${APT_CACHE_OPTION} -y -qq gnupg

sudo apt install ${APT_CACHE_OPTION} -y -qq vim ctags cscope
sudo apt install ${APT_CACHE_OPTION} -y -qq silversearcher-ag ack-grep

# Resource Monitoring
sudo apt install ${APT_CACHE_OPTION} -y -qq tmux sysstat

# Powerline
sudo apt install ${APT_CACHE_OPTION} -y -qq powerline fonts-powerline

# MOST for color manpages
sudo apt install ${APT_CACHE_OPTION} -y -qq most

