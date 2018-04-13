#!/bin/sh

LOCAL_ADMIN_PATH=~/.bin-admin
LOCAL_CONF_PATH=$LOCAL_ADMIN_PATH/config
CONF_BACKUP=/root/.config-backup

UDEV_NET_FILE=/etc/udev/rules.d/70-persistent-net.rules
NET_INTERFACE_FILE=/etc/network/interfaces

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

if [ -z "`ifconfig -a | grep eth`" ] ; then
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
fi

#	/tmp setting
echo "tmpfs /tmp tmpfs noexec,nodev,nosuid,mode=1777 0 0" | sudo tee -a /etc/fstab
sudo mount -a
sudo rm -rf /var/tmp
sudo ln -s /tmp /var/tmp

# SSD mount...
#UUID=b012b0fd-f5cc-4675-89db-3375d9a3f0bc /home ext4  defaults,discard 0 2

if [ ! -d "$LOCAL_ADMIN_PATH" ] ; then
	sudo mkdir -p $LOCAL_ADMIN_PATH
	sudo cp -a ./config $LOCAL_CONF_PATH
	sudo cp -a ./system_conf/* $LOCAL_CONF_PATH
	sudo cp -a ./*.sh $LOCAL_ADMIN_PATH
	sudo chown -R root:root $LOCAL_ADMIN_PATH
	if [ ! -e "~/bin" ] ; then
		sudo ln -s $PWD/config/home-bin/ ~/bin
		#sudo chown $USER:$USER ~/bin
	fi
	if [ ! -e "~/setting" ] ; then
		sudo ln -s $PWD/setting ~/setting
	fi
fi
