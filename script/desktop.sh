#!/bin/sh

echo "Installing Desktop Utils..."

sudo apt ${APT_CACHE_OPTION} install -y -qq vim-gtk3
sudo apt ${APT_CACHE_OPTION} install -y -qq gparted
sudo apt ${APT_CACHE_OPTION} install -y -qq mdadm
sudo apt ${APT_CACHE_OPTION} install -y -qq gksu
sudo apt ${APT_CACHE_OPTION} install -y -qq meld
sudo apt ${APT_CACHE_OPTION} install -y -qq dconf-editor gconf-editor
