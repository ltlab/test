#!/bin/sh

BC_CONFIG_PATH="$HOME/.config/bcompare"

echo -e "REMOVE: bcompare\n"
sudo apt-get -y purge bcompare

echo -e "REMOVE: configurations [ $BC_CONFIG_PATH ]\n"
rm -rfv $BC_CONFIG_PATH

echo -e "INSTALL: bcompare\n"
sudo gdebi ~/bcompare-4.1.1.20615_amd64.deb
