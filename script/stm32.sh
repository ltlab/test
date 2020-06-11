#!/bin/bash

APT="apt-get"

if [[ -z "${CI}" ]] ; then
	APT="apt"
fi

sudo ${APT} ${APT_CACHE_OPTION} install -y -qq \
	software-properties-common \
sudo add-apt-repository -y ppa:team-gcc-arm-embedded/ppa
sudo ${APT} update -qq

sudo ${APT} ${APT_CACHE_OPTION} install -y -qq \
	gcc-arm-embedded \

#sudo ${APT} clean && sudo ${APT} autoremove
#sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
