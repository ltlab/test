#!/bin/bash

APT="apt-get"

if [[ -z "${CI}" ]] ; then
	APT="apt"
fi

CONF_PATH=/root/config
CONF_BACKUP=/root/.config-backup

echo "Installing Base Service..."

sudo timedatectl set-timezone 'Asia/Seoul'
date

# SSH
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq openssh-server
sudo cp -a --backup=numbered /etc/ssh/sshd_config $CONF_BACKUP
sudo cp -a $CONF_PATH/sshd_config /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo ${APT} ${APT_CACHE_OPTION} install -y -qq zsh

sudo ${APT} ${APT_CACHE_OPTION} install -y -qq make curl cmake
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq git git-review
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq gnupg

sudo ${APT} ${APT_CACHE_OPTION} install -y -qq vim ctags cscope global shellcheck
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq silversearcher-ag ack-grep

# Resource Monitoring
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq tmux sysstat

# Powerline
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq powerline fonts-powerline

# MOST for color manpages
#sudo ${APT} ${APT_CACHE_OPTION} install -y -qq most

# TODO: Install ripgrep(rg) and fzf
# ripgrep: ubuntu 18.10 ~
# fzf: ubuntu 19.10 ~
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq ripgrep fzf stow
#curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
#sudo dpkg -i ripgrep_11.0.2_amd64.deb
#rm ripgrep_11.0.2_amd64.deb

if [[ -z "${CI}" ]] ; then
  sudo ${APT} ${APT_CACHE_OPTION} install -y -qq fail2ban
  sudo ${APT} ${APT_CACHE_OPTION} install -y -qq iptables-persistent netfilter-persistent ipset
fi
