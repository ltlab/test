#!/bin/bash

WSL=`uname -v | grep Microsoft`

set -e
#set -x	#	debug

USER_ID=$1
USER_HOME=/home/$USER_ID
NETWORK_SUBNET=$(ip a|grep -m 1 global | awk '{print $2}')

LOCAL_ADMIN_PATH=~/.bin-admin
LOCAL_CONF_PATH=$LOCAL_ADMIN_PATH/config

#CONF_PATH=/root/config
CONF_PATH=$LOCAL_CONF_PATH
CONF_BACKUP=$USER_HOME/.config-backup

ITEMS=" bashrc \
	profile \
	vimrc \
	home-bin \
	vim \
	tmux.conf \
	screenrc \
	ctags \
	gitconfig \
	dircolors-solarized \
	dircolors \
	config"

update()
{
	item=$1
	src=$CONF_PATH/$item
	dst=$USER_HOME/.$item

	#if [[ ! -e $src ]] ; then
	if [[ -z "`sudo ls $src 2>&1`" ]] ; then
		echo "WARN: $src NOT exists..."
		return 1
	fi

	# over-write directory
	# maybe... ~/.config
	if [[ -e $dst ]] && [[ -d $dst ]] ; then
		echo "Backup $item to $CONF_BACKUP..."
		sudo mv --backup=numbered $dst $CONF_BACKUP
	fi
	echo "update $src to $dst"
	sudo cp -a $src $dst

	sudo chown -R $USER_ID:$USER_ID $dst

	return 0
}

if [[ -z "$1" ]] ; then
	echo "Usage: $0 [user]"
	exit 0
fi

if [[ -z "`id -u $USER_ID`" ]] ; then
	echo "Add User $USER_ID"
	if [[ -z "$CI" ]] ; then
		sudo adduser $USER_ID
	else
		sudo adduser --disabled-password --gecos "" $USER_ID
	fi
fi

# configuration
if [[ ! -e "$CONF_BACKUP" ]] ; then
	sudo mkdir -p $CONF_BACKUP
	sudo chown $USER_ID:$USER_ID $CONF_BACKUP
fi

for item in ${ITEMS}
do
	update $item
done

if [[ -z "$WSL" ]] ; then
	# use for user's NFS directory: tailing TAB
	USER_NFS="\/nfs\/$USER_ID\	"
	if [[ -z "`grep $USER_NFS /etc/exports`" ]] ; then
		sudo mkdir -p $USER_HOME/nfs
		sudo chown $USER_ID:$USER_ID $USER_HOME/nfs
		sudo chmod g+w $USER_HOME/nfs
		sudo ln -s $USER_HOME/nfs /nfs/$USER_ID
		echo "/nfs/$USER_ID	$NETWORK_SUBNET(rw,no_root_squash,no_all_squash,subtree_check,sync)" | sudo tee -a /etc/exports
		if [[ -z "$CI" ]] ; then
			sudo systemctl restart nfs-kernel-server
		else
			sudo /etc/init.d/nfs-kernel-server restart
		fi
	fi

	if [[ ! -e "$USER_HOME/tftpboot" ]] ; then
		sudo ln -s /tftpboot $USER_HOME/tftpboot
	fi

	sudo usermod -G ftp -a $USER_ID
	sudo usermod -G tftp -a $USER_ID
	sudo usermod -G docker -a $USER_ID
	sudo usermod -G sambashare -a $USER_ID
	sudo usermod -G nfs -a $USER_ID
	sudo usermod -G plugdev -a $USER_ID	# for AOSP

	(echo 123456; echo 123456) | sudo smbpasswd -a $USER_ID
else	#	WSL
	sudo usermod -G ftp -a $USER_ID
	echo "$USER_ID" | sudo tee -a /etc/vsftpd.chroot_list
fi	#	WSL

#sudo usermod -G sudo -a $USER_ID

if [[ ! -e "$USER_HOME/bin" ]] ; then
	sudo mv $USER_HOME/.home-bin $USER_HOME/bin/
	sudo chown -R $USER_ID:$USER_ID $USER_HOME/bin
#else
#	rm -rf $USER_HOME/.home-bin
fi

# install Vundle
sudo -u $USER_ID $USER_HOME/bin/vundle.sh $USER_HOME

# install repo
sudo -u $USER_ID curl https://storage.googleapis.com/git-repo-downloads/repo -o $USER_HOME/bin/repo
sudo chmod a+x $USER_HOME/bin/repo

if [[ ! -z "$CI" ]] ; then
	service --status-all
	sudo service smbd status
	sudo service vsftpd status
	sudo service tftpd-hpa status
	#sudo service nfs-kernel-server status
	cat /etc/exports
	sudo exportfs
fi

echo "[ NOTE!!!!!!!!! ]"
echo "[ GIT ] excute git-conf.sh for e-mail registration."
echo "[ VIM ] excute vim-plugin.sh for syntax highlighting."
