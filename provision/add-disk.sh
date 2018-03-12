#!/bin/sh

DEV_NAME="/dev/sdc"
DEV_PART=${DEV_NAME}1
SWAP_PART=${DEV_NAME}2

INPUT_FILE="/tmp/input.txt"

echo "Add Disk $DEV_NAME swap: $SWAP_PART hone: $DEV_PART..."

#	Create Partition
echo "n" > $INPUT_FILE
echo "p" >> $INPUT_FILE
echo "1" >> $INPUT_FILE
echo "" >> $INPUT_FILE
echo "+196G" >> $INPUT_FILE

echo "n" >> $INPUT_FILE
echo "p" >> $INPUT_FILE
echo "2" >> $INPUT_FILE
echo "" >> $INPUT_FILE
echo "" >> $INPUT_FILE

echo "t" >> $INPUT_FILE
echo "2" >> $INPUT_FILE
echo "82" >> $INPUT_FILE	#	swap Partition

echo "p" >> $INPUT_FILE
echo "w" >> $INPUT_FILE

#echo -e "n\np\n\n\n\np\nw\n" | sudo fdisk /dev/sdc
sudo fdisk $DEV_NAME < $INPUT_FILE

rm $INPUT_FILE

sudo mkfs.ext4 $DEV_PART
sudo mkswap $SWAP_PART

# mount added disk to /home
echo "`sudo blkid | grep $DEV_PART | awk '{print $2}' | sed 's/"//g'` /home ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "`sudo blkid | grep $SWAP_PART | awk '{print $2}' | sed 's/"//g'` none swap sw 0 0" | sudo tee -a /etc/fstab

sudo mount $DEV_PART /mnt
sudo cp -a /home/* /mnt/
sudo umount /mnt

sudo mount -a

sudo swapon -a
sudo swapon -s
