# rapiddisk and rapiddisk-cache
by Jaeyeong Huh< jay.huh@ltlab.kr >

## get sources
	```
	git clone https://github.com/pkoutoupis/rapiddisk.git
	```

## Install and Uninstall
### Install
- Prepare
	```
	sudo apt install libjansson-dev libcryptsetup-dev
	sudo apt install dkms
	```
- Install Modules and tools
	```
	sudo make
	sudo make install
	sudo make tools-install

	#sudo make dkms
	sudo make dkms-install
	```
### Uninstall
	```
	sudo make dkms-Uninstall
	sudo make tools-uninstall
	sudo make uninstall
	```

### Load Modules on Boot
- Load Default
	```
	echo "rapiddisk" | tee -a /etc/modules
	echo "rapiddisk-cache" | tee -a /etc/modules
	```
- Load with parameters
	```
	echo "#rapiddisk" | tee -a /etc/modules
	echo "rapiddisk-cache" | tee -a /etc/modules

	echo "rapiddisk max_sectors=2048 nr_requests=1024" | tee -a /etc/initramfs-tools/modules
	sudo update-initramfs -u
	```

### Mount and Tuning
	```
	sudo rapiddisk --attach 2048

	sudo rapiddisk --cache-map rd0 /dev/sdb1
	sudo mount /dev/mapper/rc-wt_sdb1 $MOUNT_POINT

	sudo rapiddisk --list

	sudo echo "2048" | sudo tee /sys/block/sdb/queue/max_sectors_kb 2>&1	# 1280
	sudo echo "1024" | sudo tee /sys/block/sdb/queue/nr_requests 2>&1		# 128
	sudo echo "1024" | sudo tee /sys/block/sdb/queue/read_ahead_kb 2>&1	# 128
	sudo echo "128" | sudo tee /sys/block/sdb/device/queue_depth 2>&1		# 64
	```

