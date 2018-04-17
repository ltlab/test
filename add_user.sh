#!/bin/sh

set -e
#set -x	#	debug

WSL=`uname -v | grep Microsoft`

USER_ID=$1
USER_HOME=/home/$USER_ID

LOCAL_ADMIN_PATH=~/.bin-admin
LOCAL_CONF_PATH=$LOCAL_ADMIN_PATH/config

#CONF_PATH=/root/config
CONF_PATH=$LOCAL_CONF_PATH
CONF_BACKUP=$USER_HOME/.config-backup

ITEMS="config \
	bashrc \
	profile \
	vimrc \
	home-bin \
	vim \
	tmux.conf \
	screenrc \
	ctags \
	gitconfig \
	dircolors-solarized \
	dircolors"

update()
{
	item=$1
	src=$CONF_PATH/$item
	dst=$USER_HOME/.$item

	#if [ ! -e $src ] ; then
	if [ -z "`sudo ls $src 2>&1`" ] ; then
		echo "WARN: $src NOT exists..."
		return 1
	fi

	if [ -e $dst ] ; then
		echo "Backup $item to $CONF_BACKUP..."
		sudo mv --backup=numbered $dst $CONF_BACKUP
	fi
	echo "update $src to $dst"
	sudo cp -a $src $dst

	sudo chown -R $USER_ID:$USER_ID $dst

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
	sudo chown $USER_ID:$USER_ID $CONF_BACKUP
fi

for item in ${ITEMS}
do
	update $item
done

if [ -z "$WSL" ] ; then

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
else	#	WSL
	sudo usermod -G ftp -a $USER_ID
	echo "$USER_ID" | sudo tee -a /etc/vsftpd.chroot_list
fi	#	WSL

#sudo usermod -G sudo -a $USER_ID

if [ ! -e "$USER_HOME/bin" ] ; then
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
