#!/bin/sh

echo "Installing xRDP Service..."

# Install XFCE
sudo apt install -y xfce4 slim
#sudo apt install -y fonts-nanum* fcitx fcitx-hangul

#sudo apt install -y xfce4-goodies
#sudo apt install -y xorg dbus-x11 x11-xserver-utils

##	MATE
#sudo apt install -y mate-core mate-desktop-environment mate-notification-daemon
#echo mate-session > ~/.xsession

sudo apt install -y xrdp
#sudo systemctl restart xrdp
sudo /etc/init.d/xrdp restart
