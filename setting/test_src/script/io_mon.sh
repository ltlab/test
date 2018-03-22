#!/bin/sh
DEVICE=$1
if [ -z "$DEVICE" ]; then
	DEVICE=sda1
fi

RD_PREV=-1
WR_PREV=-1

echo "Listening $DEVICE..."

while [ 1 == 1 ] ; do
		RD=`cat /proc/diskstats | grep ${DEVICE} | awk '{print $6}'`
		WR=`cat /proc/diskstats | grep ${DEVICE} | awk '{print $10}'`

		RD_BYTE=$(( $RD * 512 ))
		WR_BYTE=$(( $WR * 512 ))

        if [ $WR_PREV -ne -1 ] ; then
                let BW_RD=$RD_BYTE-$RD_PREV
                let BW_WR=$WR_BYTE-$WR_PREV
                echo "Read: $(( $BW_RD / 1024 )) kB/s    Write: $(( $BW_WR / 1024 )) kB/s"
        fi
        RD_PREV=$RD_BYTE
        WR_PREV=$WR_BYTE
        sleep 1
done

