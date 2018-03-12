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
#(echo vagrant; echo vagrant) | sudo smbpasswd -s -a vagrant

# FTP / TFTP
sudo apt-get install -q -y vsftpd
sudo apt-get install -q -y tftpd-hpa tftp-hpa

# NFS
sudo apt-get install -q -y nfs-kernel-server
sudo cp ./server_conf/exports /etc/exports
mkdir -p /nfs
sudo groupadd nfs
sudo chown nfs:nfs /nfs
sudo chmod g+w /nfs
sudo /etc/init.d/nfs-kernel-server restart

# VCS
sudo apt-get install -q -y subversion git-core

sudo cp ./server_conf/vsftpd.conf /etc/vsftpd.conf
sudo touch /etc/vsftpd.chroot_list
sudo /etc/init.d/vsftpd restart

# Docker
sudo apt-get install -y docker.io
#sudo usermod -G docker -a $USER

# chown root.tftp <tftpboot dir>
#sudo usermod -G tftp -a $USER
sudo mkdir -p /tftpboot
sudo chown tftp:tftp /tftpboot
sudo chmod g+w /tftpboot
sudo cp ./server_conf/tftpd-hpa /etc/default/tftpd-hpa
sudo /etc/init.d/tftpd-hpa restart

# for Development
#sudo apt-get install -y powerline
sudo apt-get install -y vim ctags cscope
sudo apt-get install -y gitk
sudo apt-get install -y make

echo "Installing Development Tools for gcc..."

# for Development
sudo apt-get install -y build-essential

sudo apt-get install -y gcc-multilib g++-multilib

# for compiling kernel( menuconfig )
sudo apt-get install -y ncurses-dev libssl-dev

# Remote Desktop
#sudo apt-get install -y xrdp
#sudo apt-get install -y mate-core mate-desktop-environment mate-notification-daemon
#echo mate-session>~/.xsession
#sudo /etc/init.d/xrdp restart

#sudo smbpasswd -a $USER
