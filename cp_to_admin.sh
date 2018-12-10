#!/bin/sh

LOCAL_ADMIN_PATH=~/.bin-admin
LOCAL_CONF_PATH=$LOCAL_ADMIN_PATH/config
CONF_BACKUP=/root/.config-backup

UDEV_NET_FILE=/etc/udev/rules.d/70-persistent-net.rules
NET_INTERFACE_FILE=/etc/network/interfaces
NETPLAN_INIT_FILE=/etc/netplan/50-cloud-init.yaml

if [ -z "`which sudo`" ] ; then
	apt-get update
	apt-get install -y sudo
fi

if [ ! -e "$CONF_BACKUP" ] ; then
	sudo mkdir -p $CONF_BACKUP
fi

cat << EOF > ./interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp

#iface eth0 inet static
#	address 112.151.139.189
#	netmask 255.255.255.240
#	gateway 112.151.139.177
#dns-nameservers 203.248.252.2 164.124.101.2
#dns-nameservers 168.126.63.1 168.126.63.2 8.8.8.8

#auto eth1
#iface eth1 inet static
#	address 192.168.5.189
#	netmask 255.255.255.0
#	gateway 192.168.5.1

#pre-up iptables-restore < /etc/iptables.rules
#post-down iptables-save > /etc/iptables.rules
EOF

cat << EOF > ./netplani_init
# This file is generated from information provided by
# the datasource.  Changes to it will not persist across an instance.
# To disable cloud-init's network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eth0:
            addresses: []
            dhcp4: true
            #dhcp4: false
            #addresses: [192.168.1.230/24]
            #gateway4: 192.168.1.254
            #nameservers:
            #    addresses: [ 168.126.63.1, 8.8.8.8, 8.8.4.4 ]
        eth1:
            addresses: []
            dhcp4: true
            #dhcp4: false
            #addresses: [192.168.1.231/24]
            #gateway4: 192.168.1.254
            #nameservers:
            #    addresses: [ 168.126.63.1, 8.8.8.8, 8.8.4.4 ]
    version: 2
EOF

if [ -z "`ifconfig -a | grep eth0`" ] ; then
	echo "-----------------------"
	sudo sed -i "s/CMDLINE_LINUX=\"\"/CMDLINE_LINUX=\"net.ifnames=0 biosdevname=0\"/" /etc/default/grub
	sudo update-grub2
	if [ -e "$UDEV_NET_FILE" ] ; then
		sudo mv --backup=numbered $UDEV_NET_FILE $CONF_BACKUP
	fi
	if [ -e "$NET_INTERFACE_FILE" ] ; then
		sudo mv --backup=numbered $NET_INTERFACE_FILE $CONF_BACKUP
		sudo mv ./interfaces $NET_INTERFACE_FILE
	else
		rm ./interfaces
	fi
	if [ -e "$NETPLAN_INIT_FILE" ] ; then
		sudo mv --backup=numbered $NETPLAN_INIT_FILE $CONF_BACKUP
		#sudo vi /etc/netplan/50-cloud-init.yaml
		sudo mv ./netplan_init $NETPLAN_INIT_FILE
		sudo netplan generate
		sudo netplan apply
	fi
fi

#	/tmp setting
if [ -z "`grep \/tmp /etc/fstab`" ] ; then
	echo "tmpfs /tmp tmpfs noexec,nodev,nosuid,mode=1777 0 0" | sudo tee -a /etc/fstab
	echo "tmpfs /var/tmp tmpfs noexec,nodev,nosuid,mode=1777 0 0" | sudo tee -a /etc/fstab
else
	echo "/tmp, /var/tmp is tmpfs..."
fi

sudo mount -a
#sudo rm -rf /var/tmp
#sudo ln -s /tmp /var/tmp

# SSD mount...
#UUID=b012b0fd-f5cc-4675-89db-3375d9a3f0bc /home ext4  defaults,discard 0 2

if [ ! -d "$LOCAL_ADMIN_PATH" ] ; then
	sudo mkdir -p $LOCAL_ADMIN_PATH
	sudo cp -a ./config $LOCAL_CONF_PATH
	sudo cp -a ./system_conf/* $LOCAL_CONF_PATH
	sudo cp -a ./*.sh $LOCAL_ADMIN_PATH
	sudo chown -R root:root $LOCAL_ADMIN_PATH
	if [ ! -e ~/bin ] ; then
		sudo ln -s $PWD/config/home-bin/ ~/bin
		#sudo chown $USER:$USER ~/bin
	fi
	if [ ! -e ~/setting ] ; then
		sudo ln -s $PWD/setting ~/setting
	fi
fi
