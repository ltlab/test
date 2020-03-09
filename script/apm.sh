#!/bin/bash

APT="apt-get"

if [[ -z "${CI}" ]] ; then
	APT="apt"
fi

echo "Installing APM Service..."

sudo ${APT} ${APT_CACHE_OPTION} install -y -qq apache2
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq mysql-server mysql-client
sudo ${APT} ${APT_CACHE_OPTION} install -y -qq php libapache2-mod-php php-xml php-gd php-mysql
