#!/bin/sh

echo "Installing APM Service..."

sudo apt ${APT_CACHE_OPTION} install -y -qq apache2
sudo apt ${APT_CACHE_OPTION} install -y -qq mysql-server mysql-client
sudo apt ${APT_CACHE_OPTION} install -y -qq php libapache2-mod-php php-xml php-gd php-mysql
