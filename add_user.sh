#!/bin/sh

set -e
#set -x	#	debug

USER_ID=$1
USER_HOME=/home/$USER_ID

CONF_DIR=/root/config
CONF_BACKUP=$USER_HOME/config-backup

ITEMS="config \
	bashrc \
	vimrc \
	tmux.conf \
	screenrc \
	ctags \
	gitconfig"

update()
{
	item=$1
	src=$CONF_DIR/$item
	dst=$USER_HOME/.$item

	if [ ! -e $src ] ; then
		echo "WARN: $src NOT exists..."
		return 1
	fi

	if [ -e $dst ] ; then
		echo "Backup $item to $CONF_BACKUP..."
		sudo cp -a $dst $CONF_BACKUP
	fi
	echo "update $src to $dst"
	sudo cp -a $src $dst

	return 0
}

if [ -z "$1" ]; then
	echo "Usage: $0 [user]"
	exit 0
fi

if [ -z "`id -u $USER_ID`" ] ; then
	echo "Add User $USER_ID"
	sudo adduser $USER_ID
fi

# configuration
if [ ! -e "$CONF_BACKUP" ] ; then
	sudo mkdir -p $CONF_BACKUP
fi

for item in ${ITEMS}
do
	update $item
done

if [ -z "`grep $USER_ID /etc/exports`" ] ; then
	sudo mkdir -p $USER_HOME/nfs
	sudo chown $USER_ID:$USER_ID $USER_HOME/nfs
	sudo chmod g+w $USER_HOME/nfs
	sudo ln -s $USER_HOME/nfs /nfs/$USER_ID
	echo "/nfs/$USER_ID	192.168.10.0/255.255.255.0(rw,no_root_squash,no_all_squash,subtree_check,sync)" | sudo tee -a /etc/exports
	sudo /etc/init.d/nfs-kernel-server restart
fi

if [ ! -e "$USER_HOME/tftpboot" ] ; then
	sudo ln -s /tftpboot $USER_HOME/tftpboot
fi

sudo usermod -G ftp -a $USER_ID
sudo usermod -G tftp -a $USER_ID
sudo usermod -G docker -a $USER_ID
sudo usermod -G sambashare -a $USER_ID
sudo usermod -G nfs -a $USER_ID

(echo 123456; echo 123456) | sudo smbpasswd -a $USER_ID