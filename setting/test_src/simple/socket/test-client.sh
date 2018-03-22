#!/bin/sh

SERVER_IP="192.168.10.162"
PORT="12345"

for i in $( seq 1 50 )	#	start / step / end
do
	TIME_OUT=$(( 10 + ( $i % 10 ) ))
	echo "./TCPclient $SERVER_IP $PORT $TIME_OUT"
	exec ./TCPclient $SERVER_IP $PORT $TIME_OUT &
	sleep 1
done

