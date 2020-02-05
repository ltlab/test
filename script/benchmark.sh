#!/bin/bash

###############################################
: << "TEMP"

sudo apt install -y -qq sysbench

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

TEMP
###############################################

SYSBENCH_SHELL="$PWD/script/sysbench.sh"
RESULT_FILE=bench-result.md
MAX_TIMES=5

TEST_LIST="	cpu \
		memory \
		fileio \
		fileio-fsync"


for i in $( eval echo "{1..$MAX_TIMES}" )
do
	echo "[ $i ] ========================================"
	for item in $TEST_LIST
	do
		echo "========================================"
		echo "[ $i ] $item"
		echo "----------------------------------------"
		$SYSBENCH_SHELL $item
	done
done

LOG_FILES=$(find $HOME/sysbench/ -name "*-markdown.log" -print0 | sort -z | xargs -r0 ls)
echo "LIST: $LOG_FILES"

echo -e "#SYSBENCH Result" > $RESULT_FILE
#echo -e "by jay.huh@ltlab.kr @$(date '+%Y-%m-%d %H:%M:%S')" >> $RESULT_FILE
echo -e "by jay.huh@ltlab.kr @$(date)" >> $RESULT_FILE

echo -e "\n\`\`\`" >> $RESULT_FILE
$SYSBENCH_SHELL info >> $RESULT_FILE
echo -e "\`\`\`\n" >> $RESULT_FILE

for item in $TEST_LIST
do
	if [[ "$item" == "file-fsync" ]] ; then
		echo "SKIP: $item"
		continue
	fi

	echo "##$item" >> $RESULT_FILE

	for file in $LOG_FILES
	do
		if [[ "$file" =~ "$item" ]] ; then
			echo -e "- $item: \`$file\`\n" >> $RESULT_FILE
			cat $file >> $RESULT_FILE
		fi
	done
done

