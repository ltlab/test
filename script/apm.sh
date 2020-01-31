#!/bin/sh

echo "Installing APM Service..."

sudo apt install -y -qq apache2
sudo apt install -y -qq mysql-server mysql-client
sudo apt install -y -qq php libapache2-mod-php php-xml php-gd php-mysql
