#!/bin/sh

# Uninstall old-versions
sudo apt remove docker docker-engine docker.io containerd runc

sudo apt update -qq

# Install Packages to allow apt to use a repository over HTTPS
sudo apt ${APT_CACHE_OPTION} install -y -qq \
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

sudo apt update -qq

sudo apt ${APT_CACHE_OPTION} install -y -qq docker-ce docker-ce-cli containerd.io

# 1. List the versions available in your repo:
#apt-cache madison docker-ce
# 2. Install a specific version 
#sudo apt ${APT_CACHE_OPTION} install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io

#sudo usermod -G docker -a $USER
