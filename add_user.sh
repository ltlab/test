#!/bin/sh

if [ -z "$1" ]; then
	echo "Usage: $0 [user]"
	exit 0
fi

$USER=$1

HOME=/home/$USER

# configuration
sudo cp -av ~/config $HOME/
sudo chown -R $USER:$USER $HOME/config

sudo cp -a $HOME/config/config $HOME/.config
sudo cp -a $HOME/config/bashrc $HOME/.bashrc
sudo cp -a $HOME/config/vimrc $HOME/.vimrc
sudo cp -a $HOME/config/tmux.conf $HOME/.tmux.conf
sudo cp -a $HOME/config/screenrc $HOME/.screenrc
sudo cp -a $HOME/config/ctags $HOME/.ctags
sudo cp -a $HOME/config/gitconfig $HOME/.gitconfig

sudo mkdir -p $HOME/nfs
sudo chown $USER:$USER $HOME/nfs
sudo chmod g+w $HOME/nfs
sudo ln -s $HOME/nfs /nfs/$USER

echo "/nfs/$USER	192.168.10.0/255.255.255.0(rw,no_root_squash,no_all_squash,subtree_check,sync)" | sudo tee -a /etc/exports

sudo /etc/init.d/nfs-kernel-server restart

#sudo mkdir -p $HOME/tftpboot
#sudo chown $USER:tftp $HOME/tftpboot
#sudo chmod g+w $HOME/tftpboot
#sudo ln -s $HOME/tftpboot /tftpboot/$USER
sudo ln -s /tftpboot $HOME/tftpboot

sudo usermod -G ftp -a $USER
sudo usermod -G tftp -a $USER
sudo usermod -G docker -a $USER

(echo 123456; echo 123456) | sudo smbpasswd -a $USER
sudo usermod -G sambashare -a $USER
