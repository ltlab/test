#!/bin/sh
IF=$1
if [ -z "$IF" ]; then
        IF=`ls -1 /sys/class/net/ | head -1`
fi
RXPREV=-1
TXPREV=-1
echo "Listening $IF..."
while [ 1 == 1 ] ; do
        RX=`cat /sys/class/net/${IF}/statistics/rx_bytes`
        TX=`cat /sys/class/net/${IF}/statistics/tx_bytes`
        if [ $RXPREV -ne -1 ] ; then
                let BWRX=$RX-$RXPREV
                let BWTX=$TX-$TXPREV
                echo "Received: $(($BWRX / 1024)) kB/s    Sent: $(($BWTX /1024)) kB/s"
        fi
        RXPREV=$RX
        TXPREV=$TX
        sleep 1
done

