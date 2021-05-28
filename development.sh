#!/bin/bash

#set -e
#set -x	#	debug

WSL=`uname -a | grep -i microsoft`

APT="apt-get"

if [[ -z "${CI}" ]] ; then
	APT="apt"
fi

export APT

export SERVER="N"
export DOCKER="N"

export CONF_PATH=/root/config
export CONF_BACKUP=/root/.config-backup
export LOCAL_ADMIN_PATH=~/.bin-admin
export LOCAL_CONF_PATH=$LOCAL_ADMIN_PATH/config

echo "APT_CACHE_DIR: ${APT_CACHE_DIR} APT_CACHE_OPTION: ${APT_CACHE_OPTION}"
echo "CI: ${CI} nproc: $(nproc)"

echo "Installing System Services..."

if [[ -z "`which sudo`" ]] ; then
	${APT} update -qq
	${APT} ${APT_CACHE_OPTION} install -y -qq sudo
else
	sudo ${APT} update -qq
fi

if [[ ! -e "$CONF_BACKUP" ]] ; then
	sudo mkdir -p $CONF_BACKUP
fi

if [[ ! -e "$CONF_PATH" ]] ; then
	if [[ ! -d "$LOCAL_ADMIN_PATH" ]] ; then
		echo "WARN: $LOCAL_CONF_PATH and $CONF_PATH NOT exist..."
		./cp_to_admin.sh
		#exit 1
	fi
	sudo cp -a $LOCAL_CONF_PATH $CONF_PATH
fi

# Base: ssh, git, make, vim, cscope, ctags, ag, ack
./script/base.sh

# VCS
#sudo ${APT} ${APT_CACHE_OPTION} install -y -qq gitk
#sudo ${APT} ${APT_CACHE_OPTION} install -q -y subversion

if [[ -z "$WSL" ]] ; then
	# APM
	./script/apm.sh

	# Samba
	./script/samba.sh

	# FTP / TFTP
	./script/ftp.sh
	./script/tftp.sh

	# NFS
	./script/nfs.sh

	# for ubuntu desktop...
	if [[ "$SERVER" != "Y" ]] ; then
		./script/desktop.sh
	fi

	# Docker
	if [[ "$DOCKER" = "Y" ]] ; then
		./script/docker.sh
	fi
else
# for Windows WSL
	# FTP
	./script/ftp.sh

	#	start SSH daemon for WSL
	sudo cp -a --backup=numbered /etc/ssh/sshd_config $CONF_BACKUP
	sudo cp -a $CONF_PATH/sshd_config-wsl /etc/ssh/sshd_config
	echo "$USER ALL=(root) NOPASSWD: /usr/sbin/sshd" | sudo tee -a /etc/sudoers
	echo "$USER ALL=(root) NOPASSWD: /usr/sbin/vsftpd" | sudo tee -a /etc/sudoers

	sudo systemd-machine-id-setup
	sudo dbus-uuidgen --ensure
	cat /etc/machine-id

	sudo ${APT} -y install x11-apps xfonts-base xfonts-100dpi xfonts-75dpi xfonts-cyrillic

	sudo ${APT} -y install language-pack-ko
	sudo locale-gen ko_KR.UTF-8
	sudo ${APT} -y install fonts-unfonts-core fonts-unfonts-extra
	sudo ${APT} -y install fonts-baekmuk fonts-nanum fonts-nanum-coding fonts-nanum-extra
fi	#	WSL

#exit 0

echo "Installing Development Tools for gcc..."

# for Development
sudo dpkg --add-architecture i386
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq \
  build-essential clang-format

sudo ${APT} ${APT_CACHE_OPTION} install -y -qq \
  gcc-multilib g++-multilib gdb-multiarch

# YouCompleteMe
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq python3-dev
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq golang-go

# for compiling kernel( menuconfig )
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq ncurses-dev libssl-dev

sudo cp -a --backup=numbered /etc/profile $CONF_BACKUP/etc_profile
sudo cp -a $CONF_PATH/etc_profile /etc/profile

# Remote Desktop
if [[ "$SERVER" = "Y" ]] ; then
	./script/xrdp.sh
	sudo systemctl set-default multi-user.target
fi

# Clean ${APT} packages and cache
sudo ${APT} clean && sudo ${APT} autoremove
#sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#sudo ${APT} ${APT_CACHE_OPTION} install libpython2.7-dev
#\~/.vim/bundle/YouCompleteMe/install.sh --clang-completer

service --status-all
