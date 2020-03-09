#!/bin/bash

LOCAL_ADMIN_PATH=~/.bin-admin
LOCAL_CONF_PATH=$LOCAL_ADMIN_PATH/config
CONF_BACKUP=/root/.config-backup

UDEV_NET_FILE=/etc/udev/rules.d/70-persistent-net.rules
NET_INTERFACE_FILE=/etc/network/interfaces
NETPLAN_INIT_FILE=/etc/netplan/50-cloud-init.yaml

if [[ -z "`which sudo`" ]] ; then
	apt update -qq
	apt install -y -qq sudo
fi

if [[ ! -e "$CONF_BACKUP" ]] ; then
	sudo mkdir -p $CONF_BACKUP
fi

#echo "NET_INTERFACE_LIST: $( ls /sys/class/net )"
for item in $( ls /sys/class/net )
do
	# Start with character 'e' => eth* or en*
	if [[ $item =~ ^e ]] ; then
		IP_NETMASK=$(ip a | grep global | grep $item | awk '{print $2}')
		NETWORK=$(echo $IP_NETMASK | cut -d'.' -f 1-3 )
		GW=$( route -n | grep -m 1 $item | awk '{print $2}' | cut -d'.' -f 4 )
		GATEWAY=$NETWORK"."$GW
		echo "$item => IP + MASK=$IP_NETMASK GW=$GATEWAY"

		# NOTE: Do NOT change string format.
		printf -v NETPLAN_COMMON "
            addresses: []
            dhcp4: true

			# Static IP
            #dhcp4: false
            #addresses: [$IP_NETMASK]
            #gateway4: $GATEWAY
            #nameservers:
            #    addresses: [ 1.1.1.1, 1.0.0.1 ]

			## Use routes and routing-policy for multiple interfaces.
            #routes:
            #    - to: $NETWORK".0/24"
            #      via: $GATEWAY
            ##      metric: 100
            #      table: 100
            #routing-policy:
            #    - from: $NETWORK".0/24"
            #      table: 100"

		if [[ -z "$NET_DEVICES" ]] ; then
			NET_DEVICES=$item
			printf -v NETPLAN_LIST "        $item":"$NETPLAN_COMMON"
		else
			NET_DEVICES="$NET_DEVICES $item"
			printf -v NETPLAN_LIST "$NETPLAN_LIST\n        $item":"$NETPLAN_COMMON"
		fi
	fi
done
echo "NET_DEVICES: $NET_DEVICES"
echo "$NETPLAN_LIST"

cat << EOF > ./netplan_init
# This file is generated from information provided by
# the datasource.  Changes to it will not persist across an instance.
# To disable cloud-init's network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
$NETPLAN_LIST
    version: 2
EOF

###############################################
: << "DEBUG_NETPLAN_INIT"
exit 0
DEBUG_NETPLAN_INIT
###############################################

###############################################
: << "DISABLE_NETPLAN_INIT"
if [[ -e "$NETPLAN_INIT_FILE" ]] ; then
	sudo mv --backup=numbered $NETPLAN_INIT_FILE $CONF_BACKUP
	#sudo vi /etc/netplan/50-cloud-init.yaml
	sudo mv ./netplan_init $NETPLAN_INIT_FILE
	sudo netplan generate
	sudo netplan apply
fi
DISABLE_NETPLAN_INIT
###############################################

#	/tmp setting
echo "#tmpfs /tmp tmpfs defaults,noatime,noexec,nodev,nosuid,mode=1777,size=2G  0 0" | sudo tee -a /etc/fstab
echo "#tmpfs /var/tmp tmpfs defaults,noatime,noexec,nodev,nosuid,mode=1777,size=512M  0 0" | sudo tee -a /etc/fstab
if [[ ! -z "`grep \/tmp /etc/fstab`" ]] ; then
	echo "/tmp, /var/tmp had been mounted already..."
fi

#sudo mount -a
#sudo rm -rf /var/tmp
#sudo ln -s /tmp /var/tmp

# SSD mount...
#UUID=b012b0fd-f5cc-4675-89db-3375d9a3f0bc /home ext4  defaults,discard 0 2

if [[ ! -d "$LOCAL_ADMIN_PATH" ]] ; then
	sudo mkdir -p $LOCAL_ADMIN_PATH
	sudo cp -a ./config $LOCAL_CONF_PATH
	sudo cp -a ./system_conf/* $LOCAL_CONF_PATH
	sudo cp -a ./*.sh $LOCAL_ADMIN_PATH
	sudo chown -R root:root $LOCAL_ADMIN_PATH
	if [[ ! -e ~/bin ]] ; then
		sudo ln -s $PWD/config/home-bin/ ~/bin
		#sudo chown $USER:$USER ~/bin
	fi
	if [[ ! -e ~/setting ]] ; then
		sudo ln -s $PWD/setting ~/setting
	fi
fi
