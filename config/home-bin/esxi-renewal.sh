#!/bin/sh

VM_NAME="ubuntu-work"

# This script shuts down the UPS-Agent and resets the license
echo "Getting VMID of $VM_NAME"
vmid=$(vim-cmd vmsvc/getallvms | grep $VM_NAME | awk '{print $1}')
echo "$VM_NAME: VMID => $vmid"

echo "Getting $VM_NAME Power state"
state=$(vim-cmd vmsvc/power.getstate $vmid | grep Powered)
echo "VM is currently \"$state\""

## remove license
echo "Removing License"
rm -r /etc/vmware/license.cfg
## get a new trial license
echo "'Copying new license"
cp /etc/vmware/.#license.cfg /etc/vmware/license.cfg
## restart services
echo "'Restarting VPXA"
/etc/init.d/vpxa restart

exit 0

x=1

while [[ "$state" == "Powered on" && $x -lt 3 ]]
do
	echo "Powering off..."
	vim-cmd vmsvc/power.shutdown $vmid
	echo "Waiting for VM to power off..."

	#i=30
	#while [ $i -gt 0 ]
	#do
	#	if [ $i -gt 9 ] ; then
	#		printf "bb$i"
	#	else
	#		printf "bb $i"
	#	fi
	#	sleep 1
	#	i=`expr $i - 1`
	#done

	i=30;while [ $i -gt 0 ];do if [ $i -gt 9 ];then printf "==>$i";else  printf "==> $i";fi;sleep 1;i=`expr $i - 1`;done

	state=$(vim-cmd vmsvc/power.getstate $vmid | grep Powered)
	x=`expr $x + 1`
done

if [ "$state" == "Powered off" ] ; then
	## remove license
	echo "Removing License"
	rm -r /etc/vmware/license.cfg
	## get a new trial license
	echo "'Copying new license"
	cp /etc/vmware/.#license.cfg /etc/vmware/license.cfg
	## restart services
	echo "'Restarting VPXA"
	/etc/init.d/vpxa restart
	#echo 'Restarting Services'
	#services.sh restart
	## power on
	echo "Powering on $VM_NAME"
	vim-cmd vmsvc/power.on $vmid
else
	echo "Could not turn off $VM_NAME"
fi

echo "Finished"
