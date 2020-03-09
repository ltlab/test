#!/bin/bash

echo "Installing xRDP Service..."

# Install XFCE
sudo apt ${APT_CACHE_OPTION} install -y -qq xfce4 slim
#sudo apt ${APT_CACHE_OPTION} install -y -qq fonts-nanum* fcitx fcitx-hangul

#sudo apt ${APT_CACHE_OPTION} install -y -qq xfce4-goodies
#sudo apt ${APT_CACHE_OPTION} install -y -qq xorg dbus-x11 x11-xserver-utils

##	MATE
#sudo apt ${APT_CACHE_OPTION} install -y -qq mate-core mate-desktop-environment mate-notification-daemon
#echo mate-session > ~/.xsession

sudo apt ${APT_CACHE_OPTION} install -y -qq xrdp
if [[ -z "$CI" ]] ; then
	sudo systemctl restart xrdp
else
	sudo /etc/init.d/xrdp restart
fi
