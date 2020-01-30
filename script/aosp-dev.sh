#!/bin/bash

export CONF_PATH=/root/config
export CONF_BACKUP=/root/.config-backup
export LOCAL_ADMIN_PATH=~/.bin-admin
export LOCAL_CONF_PATH=$LOCAL_ADMIN_PATH/config

UBUNTU_VERSION=$(cat /etc/lsb-release | grep RELEASE | cut -d"=" -f2)

echo "UBUNTU VERSION is $UBUNTU_VERSION"

if [[ -z "`which sudo`" ]] ; then
	apt update
	apt install -y sudo
else
	sudo apt update
fi

if [[ ! -e "$CONF_BACKUP" ]] ; then
	sudo mkdir -p $CONF_BACKUP
fi

if [[ ! -e "$CONF_PATH" ]] ; then
	if [[ ! -d "$LOCAL_ADMIN_PATH" ]] ; then
		echo "WARN: $LOCAL_CONF_PATH and $CONF_PATH NOT exist..."
		./cp_to_admin.sh
		#exit 1
	fi
	sudo cp -a $LOCAL_CONF_PATH $CONF_PATH
fi

echo "Installing Development Tools for AOSP..."

# Install packages for AOSP
sudo apt install -y git-core \
	gnupg flex bison gperf \
	build-essential \
	gcc-multilib g++-multilib \
	libc6-dev-i386 lib32ncurses5-dev \
	zip curl zlib1g-dev \
	x11proto-core-dev libx11-dev \
	lib32z1-dev libgl1-mesa-dev \
	libxml2-utils xsltproc unzip

sudo apt install -y ccache 

if [[ "$UBUNTU_VERSION" == "18.04" ]] ; then
	sudo apt install -y lzop \
		bzip2 libbz2-dev libghc-bzlib-dev \
		squashfs-tools pngcrush liblz4-tool optipng \
		libssl-dev \
		python-pip python-dev python-networkx \
		libffi-dev libxml2-dev libxslt1-dev \
		libjpeg8-dev openjdk-8-jdk
fi	#	if [[ "$UBUNTU_VERSION" != "18.04" ]] ; then

echo -e "\n" | sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt update

sudo apt install -y openjdk-7-jdk
sudo apt install -y openjdk-8-jdk

#	Change java for lollipop by jyhuh 2018-02-22 14:12:48
sudo update-java-alternatives -s java-1.7.0-openjdk-amd64
#sudo update-alternatives --config java

#sudo apt install -y android-tools-adb
#sudo apt install -y android-tools-fastboot

sudo apt install -y adb
sudo apt install -y fastboot

sudo apt install -y python2.7-minimal
sudo ln -s python2.7 /usr/bin/python

sudo apt install -y u-boot-tools

# Android NDK / SDK
#sudo mkdir -p /usr/local/android

#echo "Downloading & Installing Android SDK..."
#cd /tmp
#sudo wget -nv http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
#sudo tar -zxf /tmp/android-sdk_r24.4.1-linux.tgz > /dev/null 2>&1
#sudo mv /tmp/android-sdk-linux /usr/local/android/sdk
#sudo rm -rf /tmp/android-sdk_r24.4.1-linux.tgz

#echo "Downloading & Installing Android NDK..."
#cd /tmp
#sudo wget -nv http://dl.google.com/android/repository/android-ndk-r11c-linux-x86_64.zip
#sudo unzip /tmp/android-ndk-r11c-linux-x86_64.zip >/dev/null 2>&1
#sudo mv /tmp/android-ndk-r11c /usr/local/android/ndk
#sudo rm -rf /tmp/android-ndk-r11c-linux-x86_64.zip

#sudo chmod -R 755 /usr/local/android

#sudo ln -s /usr/local/android/sdk/tools/android /usr/bin/android
#sudo ln -s /usr/local/android/sdk/platform-tools/adb /usr/bin/adb

#echo "Updating ANDROID_SDK, ANDROID_NDK & PATH variables..."
#cd ~/
#cat << End >> .profile
#export ANDROID_HOME="/usr/local/android/sdk"
#export ANDROID_SDK="/usr/local/android/sdk"
#export ANDROID_NDK="/usr/local/android/ndk"
#export PATH=$ANDROID_SDK/tools:$ANDROID_SDK/platform-tools:$PATH
#End

#source ~/.profile

#echo "Updating Android SDK platform-tools"
#echo "y" | sudo android update sdk --no-https --no-ui --filter platform-tools

echo "Adding USB device driver information..."
echo "For more detail see http://developer.android.com/tools/device.html"

cat << EOF > ./51-android.rules
#Acer
SUBSYSTEM=="usb", ATTR{idVendor}=="0502", MODE="0666", GROUP="plugdev"

#ASUS
SUBSYSTEM=="usb", ATTR{idVendor}=="0b05", MODE="0666", GROUP="plugdev"

#Dell
SUBSYSTEM=="usb", ATTR{idVendor}=="413", MODE="0666", GROUP="plugdev"

#Foxconn
SUBSYSTEM=="usb", ATTR{idVendor}=="0489", MODE="0666", GROUP="plugdev"

#Fujitsu/Fujitsu Toshiba
SUBSYSTEM=="usb", ATTR{idVendor}=="04c5", MODE="0666", GROUP="plugdev"

#Garmin-Asus
SUBSYSTEM=="usb", ATTR{idVendor}=="091e", MODE="0666", GROUP="plugdev"

#Google
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"

#Hisense
SUBSYSTEM=="usb", ATTR{idVendor}=="109b", MODE="0666", GROUP="plugdev"

#HTC
SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", MODE="0666", GROUP="plugdev"

#Huawei
SUBSYSTEM=="usb", ATTR{idVendor}=="12d1", MODE="0666", GROUP="plugdev"

#K-Touch
SUBSYSTEM=="usb", ATTR{idVendor}=="24e3", MODE="0666", GROUP="plugdev"

#KT Tech
SUBSYSTEM=="usb", ATTR{idVendor}=="2116", MODE="0666", GROUP="plugdev"

#Kyocera
SUBSYSTEM=="usb", ATTR{idVendor}=="0482", MODE="0666", GROUP="plugdev"

#Lenovo
SUBSYSTEM=="usb", ATTR{idVendor}=="2006", MODE="0666", GROUP="plugdev"

#LG
SUBSYSTEM=="usb", ATTR{idVendor}=="1004", MODE="0666", GROUP="plugdev"

#Motorola
SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", MODE="0666", GROUP="plugdev"

#NEC
SUBSYSTEM=="usb", ATTR{idVendor}=="0409", MODE="0666", GROUP="plugdev"

#Nook
SUBSYSTEM=="usb", ATTR{idVendor}=="2080", MODE="0666", GROUP="plugdev"

#Nvidia
SUBSYSTEM=="usb", ATTR{idVendor}=="0955", MODE="0666", GROUP="plugdev"

#OTGV
SUBSYSTEM=="usb", ATTR{idVendor}=="2257", MODE="0666", GROUP="plugdev"

#Pantech
SUBSYSTEM=="usb", ATTR{idVendor}=="10a9", MODE="0666", GROUP="plugdev"

#Pegatron
SUBSYSTEM=="usb", ATTR{idVendor}=="1d4d", MODE="0666", GROUP="plugdev"

#Philips
SUBSYSTEM=="usb", ATTR{idVendor}=="0471", MODE="0666", GROUP="plugdev"

#PMC-Sierra
SUBSYSTEM=="usb", ATTR{idVendor}=="04da", MODE="0666", GROUP="plugdev"

#Qualcomm
SUBSYSTEM=="usb", ATTR{idVendor}=="05c6", MODE="0666", GROUP="plugdev"

#SK Telesys
SUBSYSTEM=="usb", ATTR{idVendor}=="1f53", MODE="0666", GROUP="plugdev"

#Samsung
SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="plugdev"

#Sharp
SUBSYSTEM=="usb", ATTR{idVendor}=="04dd", MODE="0666", GROUP="plugdev"

#Sony
SUBSYSTEM=="usb", ATTR{idVendor}=="054c", MODE="0666", GROUP="plugdev"

#Sony Ericsson
SUBSYSTEM=="usb", ATTR{idVendor}=="0fce", MODE="0666", GROUP="plugdev"

#Teleepoch
SUBSYSTEM=="usb", ATTR{idVendor}=="2340", MODE="0666", GROUP="plugdev"

#Toshiba
SUBSYSTEM=="usb", ATTR{idVendor}=="0930", MODE="0666", GROUP="plugdev"

#ZTE
SUBSYSTEM=="usb", ATTR{idVendor}=="19d2", MODE="0666", GROUP="plugdev"
EOF

sudo mv ./51-android.rules /etc/udev/rules.d/
sudo chmod a+r /etc/udev/rules.d/51-android.rules

sudo service udev restart

curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
sudo chmod a+x ~/bin/repo
