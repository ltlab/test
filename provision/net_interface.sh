#!/bin/sh

echo "Setup for network interface..."

sudo sed -i "s/CMDLINE_LINUX=\"\"/CMDLINE_LINUX=\"net.ifnames=0 biosname=0\"/" /etc/default/grub
sudo update-grub2

sudo mv /etc/udev/rules.d/70-persistent-net.rules .
cat << EOF > ./50-cloud-init.cfg
# This file is generated from information provided by
# the datasource.  Changes to it will not persist across an instance.
# To disable cloud-init's network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}

auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF

sudo mv ./50-cloud-init.cfg /etc/network/interfaces.d/50-cloud-init.cfg
