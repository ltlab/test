#!/bin/bash

#set -e
#set -x	#	debug

CONF_PATH=/root/config
CONF_BACKUP=/root/.config-backup

if [[ -z "$1" ]] ; then
	echo "Usage: $0 [ko_KR|en_US|...]"
	exit 0
fi

LOCALE=$1".UTF-8"
LOCALE_PREFIX=$(echo $LOCALE | cut -d"_" -f1)
LANGUAGE_PACK="N"

echo "Installing Locale $LOCALE... $LOCALE_PREFIX"

# Generate Locale
sudo dpkg-reconfigure locales
#sudo locale-gen $LOCALE

# Test for Language pack
sudo apt install --dry-run language-pack-$LOCALE_PREFIX > /dev/null 2>&1
if [[ $? -eq 0 ]] ; then
	LANGUAGE_PACK="Y"
fi

echo "LANGUAGE_PACK ? $LANGUAGE_PACK"

# Install language pack
if [[ "$LANGUAGE_PACK" == "Y" ]] ; then
	sudo apt install language-pack-$LOCALE_PREFIX
fi

# Set Default locale
sudo update-locale LANG=$LOCALE LC_MESSAGES=POSIX
