#/bin/sh

RSA_KEY_FILE="$HOME/.MIIEowIBAAKCAQEAwXu+QdoZoeBgF8mMWFQaFDPHmXs+YkD+iZWa5ncCQ0ArzVCG"
RSA_OUT_FILE="$HOME/.VFvgZPO7ynPpQXfgy6RUy0Uxn5etRPTHN46Y0adzDxxKHyxFVXiJ6fpVMTaCmkVu"

SMB_SERVER=//$1
MOUNT_PATH=$2

SMB_USER="buildserver"
#SMB_PASSWD=`openssl rsautl -inkey $RSA_KEY_FILE -decrypt < $RSA_OUT_FILE`

IS_MOUNTED=$(mount | grep $MOUNT_PATH | awk '{ print $3 }')

if [ "$IS_MOUNTED" == "$MOUNT_PATH" ] ; then
	echo -e "$MOUNT_PATH was Mounted!!!!!"
	#echo -e "IS_MOUNTED: $IS_MOUNTED"
	sudo umount $MOUNT_PATH
fi

#sudo mount -t cifs -o username=$SMB_USER,password=software001,iocharset=utf8,file_mode=0664,dir_mode=0775,uid=jenkins $SMB_SERVER/$SMB_USER/release $MOUNT_PATH
mount -t cifs -o username=$SMB_USER,password=software001,iocharset=utf8,file_mode=0664,dir_mode=0775,uid=jenkins $SMB_SERVER/$SMB_USER/release $MOUNT_PATH
