#!/bin/sh

sudo apt install -y sysbench

#	CPU
#sysbench cpu --events=10000 --cpu-max-prime=20000 --time=0 --threads=4 run
sysbench --test=cpu --cpu-max-prime=20000  --num-threads=4 --max-requests=10000 --max-time=100 run

#	Memory
sysbench --test=memory --memory-block-size=1K --memory-scope=global --memory-total-size=100G --memory-oper=read --time=0 run
sysbench --test=memory --memory-block-size=1K --memory-scope=global --memory-total-size=100G --memory-oper=write --time=0 run

#	DISK IO
sysbench --test=fileio --file-total-size=8G --file-test-mode=rndrw --time=300 --max-requests=0 run
#sysbench fileio --file-total-size=8G --file-test-mode=rndrw --time=300 --max-requests=0 run

sysbench --test=fileio --file-total-size=8G cleanup


