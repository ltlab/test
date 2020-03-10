#!/bin/bash

WSL=`uname -v | grep Microsoft`

set -e
#set -x	#	debug

USER_ID=$1
USER_HOME=/home/${USER_ID}
NETWORK_SUBNET=$(ip a|grep -m 1 global | awk '{print $2}')

LOCAL_ADMIN_PATH=~/.bin-admin
LOCAL_CONF_PATH=${LOCAL_ADMIN_PATH}/config

#CONF_PATH=/root/config
CONF_PATH=${LOCAL_CONF_PATH}
CONF_BACKUP=${USER_HOME}/.config-backup

ITEMS=" bashrc \
	profile \
	vimrc \
	home-bin \
	vim \
	tmux.conf \
	screenrc \
	ctags \
	gitconfig \
	dircolors-solarized \
	dircolors \
	config \
	mostrc"

GROUP_LIST=" ftp \
	tftp \
	nfs \
	docker \
	sambashare \
	plugdev"

update()
{
	local item=$1
	local src=${CONF_PATH}/${item}
	local dst=${USER_HOME}/.${item}

	#if [[ ! -e ${src} ]] ; then
	if [[ -z "`sudo ls ${src} 2>&1`" ]] ; then
		echo "WARN: ${src} NOT exists..."
		return 1
	fi

	# over-write directory
	# maybe... ~/.config
	if [[ -e ${dst} ]] && [[ -d ${dst} ]] ; then
		echo "Backup ${item} to ${CONF_BACKUP}..."
		sudo mv --backup=numbered ${dst} ${CONF_BACKUP}
	fi
	echo "update ${src} to ${dst}"
	sudo cp -a ${src} ${dst}

	sudo chown -R ${USER_ID}:${USER_ID} ${dst}

	return 0
}

find_group()
{
	local group=$1
	local ret=1

	if [[ -z $(grep -E "^${group}" /etc/group) ]] ; then
		ret=0
	fi

	echo "${ret}"
}

if [[ -z "$1" ]] ; then
	echo "Usage: $0 [user]"
	exit 0
fi

if [[ -z "`id -u ${USER_ID}`" ]] ; then
	echo "Add User ${USER_ID}"
	if [[ -z "${CI}" ]] ; then
		sudo adduser ${USER_ID}
	else
		sudo adduser --disabled-password --gecos "" ${USER_ID}
	fi
fi

# configuration
if [[ ! -e "${CONF_BACKUP}" ]] ; then
	sudo mkdir -p ${CONF_BACKUP}
	sudo chown ${USER_ID}:${USER_ID} ${CONF_BACKUP}
fi

for item in ${ITEMS}
do
	update ${item}
done

if [[ -z "${WSL}" ]] ; then
	# use for user's NFS directory: tailing TAB
	if [[ ! -z $(grep -E "^nfs" /etc/group) ]] ; then
		USER_NFS="\/nfs\/${USER_ID}\	"
		if [[ -z "`grep ${USER_NFS} /etc/exports`" ]] ; then
			sudo mkdir -p ${USER_HOME}/nfs
			sudo chown ${USER_ID}:nfs ${USER_HOME}/nfs
			# Set group permission for Write and setgid.
			sudo chmod g+ws ${USER_HOME}/nfs
			sudo ln -s ${USER_HOME}/nfs /nfs/${USER_ID}
			echo "/nfs/${USER_ID}	${NETWORK_SUBNET}(rw,no_root_squash,no_all_squash,subtree_check,sync)" | sudo tee -a /etc/exports
			if [[ -z "${CI}" ]] ; then
				sudo systemctl restart nfs-kernel-server
			else
				sudo /etc/init.d/nfs-kernel-server restart
			fi
		fi	# /etc/exports
	fi	# nfs

	if [[ ! -z $(grep -E "^tftp" /etc/group) ]] ; then
		if [[ -d "/tftpboot" && ! -e "${USER_HOME}/tftpboot" ]] ; then
			sudo ln -s /tftpboot ${USER_HOME}/tftpboot
		fi
	fi	#	tftp

	for group in ${GROUP_LIST}
	do
		if [[ $(find_group ${group}) -eq 1 ]] ; then
			echo "[ ADD ] ${USER_ID} to Group ${group}"
			sudo usermod -G ${group} -a ${USER_ID}
		else
			echo "[ WARN ] Group ${group} is NOT found!!!"
		fi
	done

	if [[ $(find_group sambashare) -eq 1 ]] ; then
		(echo 123456; echo 123456) | sudo smbpasswd -a ${USER_ID}
	fi
else	#	WSL
	sudo usermod -G ftp -a ${USER_ID}
	echo "${USER_ID}" | sudo tee -a /etc/vsftpd.chroot_list
fi	#	WSL

#sudo usermod -G sudo -a ${USER_ID}

if [[ ! -e "${USER_HOME}/bin" ]] ; then
	sudo mv ${USER_HOME}/.home-bin ${USER_HOME}/bin/
	sudo chown -R ${USER_ID}:${USER_ID} ${USER_HOME}/bin
#else
#	rm -rf ${USER_HOME}/.home-bin
fi

# install Vundle
sudo -u ${USER_ID} ${USER_HOME}/bin/vundle.sh ${USER_HOME}

# install repo
sudo -u ${USER_ID} curl https://storage.googleapis.com/git-repo-downloads/repo -o ${USER_HOME}/bin/repo
sudo chmod a+x ${USER_HOME}/bin/repo

if [[ ! -z "${CI}" ]] ; then
	service --status-all
	sudo service smbd status
	sudo service vsftpd status
	echo "================"
	cat /etc/default/tftpd-hpa
	echo "================"
	sudo service tftpd-hpa status
	echo "================"
	#sudo service nfs-kernel-server status
	cat /etc/exports
	sudo exportfs
fi

echo "[ NOTE!!!!!!!!! ]"
echo "[ GIT ] excute git-conf.sh for e-mail registration."
echo "[ VIM ] excute vim-plugin.sh for syntax highlighting."
