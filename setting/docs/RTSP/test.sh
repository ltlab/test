#!/bin/sh

DURATION=100

rm tmp_*.mov

for index in $(seq 1 10)
do
	echo [$index]:
	../openRTSP  -q -V -w 1280 -h 720 -f 30 -d $DURATION rtsp://192.168.10.44/cam0_0 > tmp_$index.mov &
done

#../openRTSP  -d 10 -V rtsp://192.168.10.44/cam0_0 &
