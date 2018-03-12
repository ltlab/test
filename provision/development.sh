#!/bin/sh

echo "Installing Development Tools for gcc..."

# for Development
sudo apt-get install -y build-essential

#sudo dpkg --add-architecture i386
#sudo apt-get update -y > /dev/null 2>&1

sudo apt-get install -y gcc-multilib g++-multilib

# for compiling kernel( menuconfig )
sudo apt-get install -y ncurses-dev libssl-dev

# Remote Desktop
#sudo apt-get install -y xrdp
#sudo apt-get install -y mate-core mate-desktop-environment mate-notification-daemon
#echo mate-session>~/.xsession
#sudo /etc/init.d/xrdp restart
