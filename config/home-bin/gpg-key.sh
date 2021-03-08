#!/bin/bash

COLOR_SH="$HOME/bin/color.sh"

help()
{
	echo "Usage: $(basename $0) [-i filename | -e keyid -o filename ]"
	#echo "where  OPTIONS := "
	echo "  -i filename             Import GPG key from file"
	echo "  -e keyid -o filename    Export GPG key to file"
	exit 1;
}

if [ -e $COLOR_SH ] ; then
	source $COLOR_SH
	#echo -e $RED_BOLD"Including Color.sh"$ENDCOLOR
fi

echo -e $WHITE_BOLD"===== GPG Import/Export =====\n"$ENDCOLOR

OPTSPEC="hvi:e:o:"

FILE="gpg_export"
GPG_CMD_1="--help"
GPG_CMD_2=""

while getopts $OPTSPEC  opt ; do
	case $opt in
		i )
			FILE=$OPTARG
			ACTION="IMPORT file: $FILE"
			GPG_CMD_1="gpg --import ${FILE}.pub"
			GPG_CMD_2="gpg --import ${FILE}.secret"
			;;
		e )
			KEY_ID=$OPTARG
			ACTION="EXPORT Key: $KEY_ID"
			FILE="gpg_"$KEY_ID
			GPG_CMD_1="gpg --armor --output ${FILE}.pub --export $KEY_ID"
			GPG_CMD_2="gpg --armor --output ${FILE}.pub --export-secret-keys $KEY_ID"
			;;
		o )
			FILE=$OPTARG
			;;
		h|* )
			help
			exit 1
			;;
		v )
			echo "opt: $opt OPTARG: $OPTARG"
			echo "Verbose: $OPTARG"
			;;
	esac
done

echo -e $YELLOW_BOLD"[ GPG ] $ACTION"$ENDCOLOR
$GPG_CMD_1
$GPG_CMD_2

echo -e $GREEN_BOLD"gpg --list-keys --keyid-format SHORT"$ENDCOLOR
gpg --list-keys --keyid-format SHORT

exit 0
