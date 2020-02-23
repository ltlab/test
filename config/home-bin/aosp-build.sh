#!/bin/bash

DEBUG=

SOURCE_TOP="$HOME/home-cached/jay/work/android_build"
LOG_PATH="$HOME/log/auto-log"
SUMMARY_FILE=${LOG_PATH}/summary.txt
BOARD_CFG="evk_8mm-userdebug"

TIMES=3
PREFIX=
INTERVAL=3
MIN_JOB=16

JOBS_LIST=$( for (( i = $(nproc) ; i >= ${MIN_JOB} ; i = $(( i>>1 )) )) ; do echo -n "$i " ; done )

help()
{
	echo "Usage: $(basename $0) [-t TIMES | -p LOG_PREFIX | -i INTERVAL ]"
	#echo "where  OPTIONS := "
	echo "  -d              Debug mode."
	echo "  -t TIMES        Build Count. default 3"
	echo "  -p LOG_PREFIX   LOG_PREFIX."
	echo "  -i INTERVAL     Interval between builds. default 3 seconds."
	exit 1;
}

OPTSPEC="hdt:p:i:"
while getopts $OPTSPEC  opt ; do
	case $opt in
		d )
			DEBUG=1
			;;
		t )
			TIMES=$OPTARG
			;;
		p )
			PREFIX=$OPTARG
			;;
		i )
			INTERVAL=$OPTARG
			;;
		h )
			help
			exit 1
			;;
		\? )
			echo "Invalid option $opt"
			help
			exit 1
			;;
	esac
done

build()
{
	local IDX=$1
	local JOB=$2
	LOG_FILE="build-${HOSTNAME}-v$(nproc)-${PREFIX}j${JOB}-${IDX}.log"

	if [[ ! -z "${DEBUG}" ]] ; then
		time echo "make -j${JOB}" 2>&1 | tee /tmp/${LOG_FILE} && mv /tmp/${LOG_FILE} ${LOG_PATH}
		return 0
	fi

	time make clean && time make clobber
	time lunch ${BOARD_CFG}
	ccache -z
	echo -e "[${idx}] JOB=${job} Build START: $(date)"
	echo -e "log: ${LOG_FILE}"
	make -j${JOB} 2>&1 | tee /tmp/${LOG_FILE} && mv /tmp/${LOG_FILE} ${LOG_PATH}
	echo -e "[${idx}] JOB=${job} Build END: $(date)"

	return 0
}

echo -e "HOSTNAME: ${HOSTNAME}"
echo -e "PREFIX: ${PREFIX}"
echo -e "JOBS_LIST: ${JOBS_LIST}"
echo -e "TIMES: ${TIMES}"
echo -e "INTERVAL: ${INTERVAL}"

mkdir -p ${LOG_PATH}
if [[ -z "${DEBUG}" ]] ; then
	cd ${SOURCE_TOP}
	time source  build/envsetup.sh
fi

for idx in $( seq 1 ${TIMES} )
do
	for job in ${JOBS_LIST}
	do
		echo -e "[${idx}] JOB=${job} START: $(date)"
		build ${idx} ${job}

		sleep ${INTERVAL}
	done
done

if [[ ! -z "${DEBUG}" ]] ; then
	ls -lh ${LOG_PATH}
	LOG_PATH=$HOME/log
fi

LOG_FILES=$(find ${LOG_PATH} -name "build-*" -print0 | sort -z | xargs -r0 ls)
date 2>&1 | tee ${SUMMARY_FILE}
echo -e "HOSTNAME: ${HOSTNAME}" >> ${SUMMARY_FILE}
echo -e "PREFIX: ${PREFIX}" >> ${SUMMARY_FILE}
echo -e "JOBS_LIST: ${JOBS_LIST}" >> ${SUMMARY_FILE}
echo -e "TIMES: ${TIMES}" >> ${SUMMARY_FILE}
echo -e "INTERVAL: ${INTERVAL}" >> ${SUMMARY_FILE}

for LOG_FILE in ${LOG_FILES}
do
	echo -e "\nLOG_FILE: ${LOG_FILE}" 2>&1 | tee -a ${SUMMARY_FILE}
	tail -n 20 ${LOG_FILE} | grep successful | tee -a ${SUMMARY_FILE}
done

exit 0
