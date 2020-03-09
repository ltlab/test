#!/bin/bash

echo "Installing xRDP Service..."

# Install XFCE
sudo apt install ${APT_CACHE_OPTION} -y -qq xfce4 slim
#sudo apt install ${APT_CACHE_OPTION} -y -qq fonts-nanum* fcitx fcitx-hangul

#sudo apt install ${APT_CACHE_OPTION} -y -qq xfce4-goodies
#sudo apt install ${APT_CACHE_OPTION} -y -qq xorg dbus-x11 x11-xserver-utils

##	MATE
#sudo apt install ${APT_CACHE_OPTION} -y -qq mate-core mate-desktop-environment mate-notification-daemon
#echo mate-session > ~/.xsession

sudo apt install ${APT_CACHE_OPTION} -y -qq xrdp
if [[ -z "$CI" ]] ; then
	sudo systemctl restart xrdp
else
	sudo /etc/init.d/xrdp restart
fi
