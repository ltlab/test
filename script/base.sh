#!/bin/sh

CONF_PATH=/root/config
CONF_BACKUP=/root/.config-backup

echo "Installing Base Service..."

sudo timedatectl set-timezone 'Asia/Seoul'
date

# SSH
sudo apt ${APT_CACHE_OPTION} install -y -qq openssh-server
sudo cp -a --backup=numbered /etc/ssh/sshd_config $CONF_BACKUP
sudo cp -a $CONF_PATH/sshd_config /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo apt ${APT_CACHE_OPTION} install -y -qq make curl
sudo apt ${APT_CACHE_OPTION} install -y -qq git git-review
sudo apt ${APT_CACHE_OPTION} install -y -qq gnupg

sudo apt ${APT_CACHE_OPTION} install -y -qq vim ctags cscope
sudo apt ${APT_CACHE_OPTION} install -y -qq silversearcher-ag ack-grep

# Resource Monitoring
sudo apt ${APT_CACHE_OPTION} install -y -qq tmux sysstat

# Powerline
sudo apt ${APT_CACHE_OPTION} install -y -qq powerline fonts-powerline

# MOST for color manpages
sudo apt ${APT_CACHE_OPTION} install -y -qq most

