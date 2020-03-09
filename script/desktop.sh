#!/bin/bash

APT="apt-get"

if [[ -z "${CI}" ]] ; then
	APT="apt"
fi

echo "Installing Desktop Utils..."

sudo ${APT} ${APT_CACHE_OPTION} install -y -qq vim-gtk3
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq gparted
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq mdadm
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq gksu
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq meld
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq dconf-editor gconf-editor
