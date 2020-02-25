#!/bin/bash

set -e

DEBUG=

SRC_PATH="$HOME/home-cached/jay/work/android_build"
BOARD_CFG="evk_8mm-userdebug"
LOG_PATH="$HOME/log/auto-log"
TIMES=3
PREFIX=
INTERVAL=3

MIN_JOB=16
MIN_JOB=$(nproc)
JOBS_LIST=$( for (( i = $(nproc) ; i >= ${MIN_JOB} ; i = $(( i>>1 )) )) ; do echo -n "$i " ; done )

GREP_CMD=$( if [[ -z $( command -v ag ) ]] ; then echo "grep" ; else echo "ag --nonumbers" ; fi )
TIMESTAMP=$( date +%s )

help()
{
	echo "Usage: $(basename $0) [ -s SRC_PATH | -b BOARD_CFG | -l LOG_PATH | -t TIMES | -p LOG_PREFIX | -i INTERVAL | -d ]"
	#echo "where  OPTIONS := "
	echo "  -s SRC_PATH     AOSP Source top directory"
	echo "  -b BOARD_CFG    Board configration rules. ex) evk_8mm-userdeg"
	echo "  -l LOG_PATH     Log directory. default ~/log/auto-log"
	echo "  -t TIMES        Build Count. default 3"
	echo "  -p LOG_PREFIX   LOG_PREFIX"
	echo "  -i INTERVAL     Interval between builds. default 3 seconds"
	echo "  -d              Debug mode"
	echo "  -h              Display this help and exit"
	exit 1;
}

OPTSPEC="hds:b:l:t:p:i:"
while getopts $OPTSPEC  opt ; do
	case $opt in
		d )
			DEBUG=1
			;;
		s )
			SRC_PATH=$OPTARG
			;;
		l )
			LOG_PATH=$OPTARG
			;;
		b )
			BOARD_CFG=$OPTARG
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

if [[ -z $1 ]] ; then
	help
	exit 1
fi

SUMMARY_FILE=${LOG_PATH}/summary.md

build()
{
	local IDX=$1
	local JOB=$2
	local LOG_FILE=$3
	local TMP_LOGFILE="/tmp/${LOG_FILE}"

	if [[ ! -z "${DEBUG}" ]] ; then
		echo -e "[${IDX}] JOB=${JOB} Testing START: $(date) TS: ${TIMESTAMP}" 2>&1 | tee -a ${TMP_LOGFILE}
		sleep 0.2
		echo -e "[${IDX}] JOB=${JOB} Testing END: $(date) TS: ${TIMESTAMP}" 2>&1 | tee -a ${TMP_LOGFILE}
		return 0
	fi

	echo -e "[${IDX}] JOB=${JOB} Cleaning START: $(date) TS: ${TIMESTAMP}" 2>&1 | tee -a ${TMP_LOGFILE}
	time make clean && time make clobber
	echo -e "[${IDX}] JOB=${JOB} Cleaning END: $(date) TS: ${TIMESTAMP}" 2>&1 | tee -a ${TMP_LOGFILE}
	echo -e "[${IDX}] JOB=${JOB} Configure START: $(date) TS: ${TIMESTAMP}" 2>&1 | tee -a ${TMP_LOGFILE}
	time lunch ${BOARD_CFG}
	echo -e "[${IDX}] JOB=${JOB} Configure END: $(date) TS: ${TIMESTAMP}" 2>&1 | tee -a ${TMP_LOGFILE}
	ccache -z
	echo -e "[${IDX}] JOB=${JOB} Build START: $(date) TS: ${TIMESTAMP}" 2>&1 | tee -a ${TMP_LOGFILE}
	make -j${JOB} 2>&1 | tee -a ${TMP_LOGFILE}
	echo -e "[${IDX}] JOB=${JOB} Build END: $(date) TS: ${TIMESTAMP}" 2>&1 | tee -a ${TMP_LOGFILE}

	return 0
}

echo -e "HOSTNAME: ${HOSTNAME}"
echo -e "PREFIX: ${PREFIX}"
echo -e "JOBS_LIST: ${JOBS_LIST}"
echo -e "TIMES: ${TIMES}"
echo -e "INTERVAL: ${INTERVAL}"

mkdir -p ${LOG_PATH}
if [[ -z "${DEBUG}" ]] ; then
	cd ${SRC_PATH}
	time source  build/envsetup.sh
fi

for idx in $( seq 1 ${TIMES} )
do
	offset=0

	for job in ${JOBS_LIST}
	do
		while true
		do
			LOG_FILE="build-${HOSTNAME}-v$(nproc)-${PREFIX}j${job}-$( printf "%03d" $(( $idx + $offset )) ).log"
			if [[ -e "${LOG_PATH}/${LOG_FILE}" ]] ; then
				offset=$(( offset + 1 ))
			else
				break
			fi
		done

		TMP_LOGFILE="/tmp/${LOG_FILE}"

		echo -e "[${idx}] JOB=${job} ======== START: $(date) TS: ${TIMESTAMP} LOG_FILE: ${LOG_FILE}" 2>&1 | tee ${TMP_LOGFILE}
		build ${idx} ${job} ${LOG_FILE}
		echo -e "[${idx}] JOB=${job} ======== END: $(date) TS: ${TIMESTAMP}" 2>&1 | tee -a ${TMP_LOGFILE}
		mv ${TMP_LOGFILE} ${LOG_PATH}

		sleep ${INTERVAL}
	done
done

#if [[ ! -z "${DEBUG}" ]] ; then
#	ls -lh ${LOG_PATH}
#fi

echo -e "\n\n"

LOG_FILES=$(find ${LOG_PATH} -name "build-*" -print0 | sort -z | xargs -r0 ls)
echo -e "# AOSP Build Test Summary\n" 2>&1 | tee ${SUMMARY_FILE} > /dev/null
echo -e "Tested at $(date)\n" 2>&1 | tee -a ${SUMMARY_FILE}

echo -e "##Test configration\n" 2>&1 | tee -a ${SUMMARY_FILE}
echo -e "- SRC_PATH: \`${SRC_PATH}\`" 2>&1 | tee -a ${SUMMARY_FILE}
echo -e "- BOARD_CFG: \`${BOARD_CFG}\`" 2>&1 | tee -a ${SUMMARY_FILE}
echo -e "- LOG_PATH: \`${LOG_PATH}\`" 2>&1 | tee -a ${SUMMARY_FILE}
echo -e "- HOSTNAME: \`${HOSTNAME}\`" 2>&1 | tee -a ${SUMMARY_FILE}
echo -e "- PREFIX: \`${PREFIX}\`" 2>&1 | tee -a ${SUMMARY_FILE}
echo -e "- JOBS_LIST: \`${JOBS_LIST}\`" 2>&1 | tee -a ${SUMMARY_FILE}
echo -e "- TIMES: ${TIMES}" 2>&1 | tee -a ${SUMMARY_FILE}
echo -e "- INTERVAL: ${INTERVAL} seconds" 2>&1 | tee -a ${SUMMARY_FILE}

for LOG_FILE in ${LOG_FILES}
do
	echo -e "\nLOG_FILE: ${LOG_FILE}" 2>&1 | tee -a ${SUMMARY_FILE} > /dev/null

	if [[ ! -z "${DEBUG}" ]] ; then
		${GREP_CMD} "= START" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE} > /dev/null
		${GREP_CMD} "Testing START" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE} > /dev/null
		tail -n 20 ${LOG_FILE} | ${GREP_CMD} successful 2>&1 | tee -a ${SUMMARY_FILE} > /dev/null
		${GREP_CMD} "Testing END" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE} > /dev/null
		${GREP_CMD} "= END" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE} > /dev/null

		continue
	fi

	#${GREP_CMD} "= START" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE} > /dev/null
	${GREP_CMD} "Cleaning START" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE} > /dev/null
	${GREP_CMD} "Configure START" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE} > /dev/null
	${GREP_CMD} "Build START" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE} > /dev/null
	tail -n 20 ${LOG_FILE} | ${GREP_CMD} successful 2>&1 | tee -a ${SUMMARY_FILE} > /dev/null
	${GREP_CMD} "Build END" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE} > /dev/null
	${GREP_CMD} "= END" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE} > /dev/null
done

exit 0
