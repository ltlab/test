#!/bin/bash

APT="apt-get"

if [[ -z "${CI}" ]] ; then
	APT="apt"
fi

if [[ -z "$1" ]] ; then
	echo "Usage: $0 [ko_KR|en_US|...]"
	exit 0
fi

LOCALE=$1".UTF-8"
LOCALE_PREFIX=$(echo $LOCALE | cut -d"_" -f1)
LANGUAGE_PACK="N"

echo "Installing Locale $LOCALE... $LOCALE_PREFIX"

# Generate Locale
#sudo dpkg-reconfigure locales
sudo locale-gen ${LOCALE}
# Set Default locale
sudo update-locale LANG=$LOCALE LC_MESSAGES=POSIX

# Set Timezone
sudo timedatectl set-timezone 'Asia/Seoul'

# Uninstall old-versions
sudo ${APT} remove docker docker-engine docker.io containerd runc

sudo ${APT} update

# Install Packages to allow ${APT} to use a repository over HTTPS
sudo ${APT} ${APT_CACHE_OPTION} install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg-agent \
	software-properties-common

# Get Docker Official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify key
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable"

sudo ${APT} update

sudo ${APT} ${APT_CACHE_OPTION} install -y docker-ce docker-ce-cli containerd.io

# 1. List the versions available in your repo:
#apt-cache madison docker-ce
# 2. Install a specific version 
#sudo ${APT} ${APT_CACHE_OPTION} install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io

sudo usermod -G docker -a $USER
