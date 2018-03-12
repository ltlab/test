#!/bin/sh

echo "Installing System Services..."
sudo apt-get update -y > /dev/null 2>&1

# APM
#sudo apt-get install -y apache2
#sudo apt-get install -y mysql-server mysql-client
#sudo apt-get install -y php libapache2-mod-php php-xml php-gd php-mysql

# SSH
sudo apt-get install -q -y openssh-server

# Samba
sudo apt-get install -q -y samba
#sudo smbpasswd -a jyhuh
#sudo vi /etc/samba/smb.conf
sudo cp ./server_conf/smb.conf /etc/samba/smb.conf
sudo /etc/init.d/smbd restart
#echo -e "vagrant\nvagrant" | sudo smbpasswd -a vagrant
(echo vagrant; echo vagrant) | sudo smbpasswd -s -a vagrant

# FTP / TFTP
sudo apt-get install -q -y vsftpd
sudo apt-get install -q -y tftpd-hpa tftp-hpa

# NFS
sudo apt-get install -q -y nfs-kernel-server
sudo cp ./server_conf/exports /etc/exports
mkdir -p ./nfs
sudo chown vagrant:vagrant ./nfs
sudo chmod g+w ./nfs
sudo /etc/init.d/nfs-kernel-server restart

# VCS
sudo apt-get install -qq subversion git-core

sudo cp ./server_conf/vsftpd.conf /etc/vsftpd.conf
sudo touch /etc/vsftpd.chroot_list
sudo /etc/init.d/vsftpd restart

# Docker
sudo apt-get install -y docker.io
sudo usermod -G docker -a vagrant

# chown root.tftp <tftpboot dir>
sudo usermod -G tftp -a vagrant
mkdir -p ./tftpboot
sudo chown vagrant:tftp ./tftpboot
sudo chmod g+w ./tftpboot
sudo cp ./server_conf/tftpd-hpa /etc/default/tftpd-hpa
sudo /etc/init.d/tftpd-hpa restart

# for Development
#sudo apt-get install -y powerline
sudo apt-get install -y vim ctags cscope
sudo apt-get install -y gitk
sudo apt-get install -y make

# configuration
sudo chmod a+x ./config/git-conf.sh
sudo cp -a ./config/config ./.config
sudo cp -a ./config/bashrc ./.bashrc
sudo cp -a ./config/vimrc ./.vimrc
sudo cp -a ./config/tmux.conf ./.tmux.conf
sudo cp -a ./config/screenrc ./.screenrc
sudo cp -a ./config/ctags ./.ctags
sudo cp -a ./config/gitconfig ./.gitconfig
