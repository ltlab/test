#!/bin/sh

echo "Installing Desktop Utils..."

sudo apt install ${APT_CACHE_OPTION} -y -qq vim-gtk3
sudo apt install ${APT_CACHE_OPTION} -y -qq gparted
sudo apt install ${APT_CACHE_OPTION} -y -qq mdadm
sudo apt install ${APT_CACHE_OPTION} -y -qq gksu
sudo apt install ${APT_CACHE_OPTION} -y -qq meld
sudo apt install ${APT_CACHE_OPTION} -y -qq dconf-editor gconf-editor
