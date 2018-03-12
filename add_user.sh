#!/bin/sh

set -ex

if [ -z "$1" ]; then
	echo "Usage: $0 [user]"
	exit 0
fi

USER_ID=$1

sudo adduser $USER_ID

USER_HOME=/home/$USER_ID

# configuration
sudo cp -av ~/dev-env/config $USER_HOME/
sudo chown -R $USER_ID:$USER_ID $USER_HOME/config

sudo cp -a $USER_HOME/config/config $USER_HOME/.config
sudo cp -a $USER_HOME/config/bashrc $USER_HOME/.bashrc
sudo cp -a $USER_HOME/config/vimrc $USER_HOME/.vimrc
sudo cp -a $USER_HOME/config/tmux.conf $USER_HOME/.tmux.conf
sudo cp -a $USER_HOME/config/screenrc $USER_HOME/.screenrc
sudo cp -a $USER_HOME/config/ctags $USER_HOME/.ctags
sudo cp -a $USER_HOME/config/gitconfig $USER_HOME/.gitconfig

sudo mkdir -p $USER_HOME/nfs
sudo chown $USER_ID:$USER_ID $USER_HOME/nfs
sudo chmod g+w $USER_HOME/nfs
sudo ln -s $USER_HOME/nfs /nfs/$USER_ID

echo "/nfs/$USER_ID	192.168.10.0/255.255.255.0(rw,no_root_squash,no_all_squash,subtree_check,sync)" | sudo tee -a /etc/exports

sudo /etc/init.d/nfs-kernel-server restart

#sudo mkdir -p $USER_HOME/tftpboot
#sudo chown $USER_ID:tftp $USER_HOME/tftpboot
#sudo chmod g+w $USER_HOME/tftpboot
#sudo ln -s $USER_HOME/tftpboot /tftpboot/$USER_ID
sudo ln -s /tftpboot $USER_HOME/tftpboot

sudo usermod -G ftp -a $USER_ID
sudo usermod -G tftp -a $USER_ID
sudo usermod -G docker -a $USER_ID

(echo 123456; echo 123456) | sudo smbpasswd -a $USER_ID
sudo usermod -G sambashare -a $USER_ID
