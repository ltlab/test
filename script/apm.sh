#!/bin/sh

echo "Installing APM Service..."

sudo apt install ${APT_CACHE_OPTION} -y -qq apache2
sudo apt install ${APT_CACHE_OPTION} -y -qq mysql-server mysql-client
sudo apt install ${APT_CACHE_OPTION} -y -qq php libapache2-mod-php php-xml php-gd php-mysql
