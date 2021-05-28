#!/bin/bash

APT="apt-get"

if [[ -z "${CI}" ]] ; then
	APT="apt"
fi

sudo ${APT} update -qq
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq binwalk


sudo ${APT} install -y -qq \
  git build-essential \
  zlib1g-dev liblzma-dev \
  python-magic bsdmainutils autoconf
