#!/bin/sh

SIZE=1G

for i in $(seq 1 1 1700)
do
	echo "make dummy-$SIZE-$i"
	dd if=/dev/zero of=dummy-$SIZE-$i bs=32M count=32
done


