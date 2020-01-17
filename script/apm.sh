#!/bin/sh

echo "Installing APM Service..."

sudo apt install -y apache2
sudo apt install -y mysql-server mysql-client
sudo apt install -y php libapache2-mod-php php-xml php-gd php-mysql
