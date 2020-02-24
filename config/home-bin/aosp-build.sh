#!/bin/bash

DEBUG=

SOURCE_TOP="$HOME/home-cached/jay/work/android_build"
BOARD_CFG="evk_8mm-userdebug"
LOG_PATH="$HOME/log/auto-log"
TIMES=3
PREFIX=
INTERVAL=3

MIN_JOB=16
JOBS_LIST=$( for (( i = $(nproc) ; i >= ${MIN_JOB} ; i = $(( i>>1 )) )) ; do echo -n "$i " ; done )

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
			SOURCE_TOP=$OPTARG
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
	local LOG_FILE="build-${HOSTNAME}-v$(nproc)-${PREFIX}j${JOB}-${IDX}.log"
	local TMP_LOGFILE="/tmp/${LOG_FILE}"

	if [[ ! -z "${DEBUG}" ]] ; then
		echo -e "[${IDX}] JOB=${JOB} Testing START: $(date)" 2>&1 | tee -a ${TMP_LOGFILE}
		sleep 0.2
		echo -e "[${IDX}] JOB=${JOB} Testing END: $(date)" 2>&1 | tee -a ${TMP_LOGFILE}
		return 0
	fi

	echo -e "[${IDX}] JOB=${JOB} Cleaning START: $(date)" 2>&1 | tee -a ${TMP_LOGFILE}
	time make clean && time make clobber
	echo -e "[${IDX}] JOB=${JOB} Cleaning END: $(date)" 2>&1 | tee -a ${TMP_LOGFILE}
	echo -e "[${IDX}] JOB=${JOB} Configure START: $(date)" 2>&1 | tee -a ${TMP_LOGFILE}
	time lunch ${BOARD_CFG}
	echo -e "[${IDX}] JOB=${JOB} Configure END: $(date)" 2>&1 | tee -a ${TMP_LOGFILE}
	ccache -z
	echo -e "[${IDX}] JOB=${JOB} Build START: $(date)" 2>&1 | tee -a ${TMP_LOGFILE}
	make -j${JOB} 2>&1 | tee -a ${TMP_LOGFILE}}
	echo -e "[${IDX}] JOB=${JOB} Build END: $(date)" 2>&1 | tee -a ${TMP_LOGFILE}

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
		LOG_FILE="build-${HOSTNAME}-v$(nproc)-${PREFIX}j${job}-${idx}.log"
		TMP_LOGFILE="/tmp/${LOG_FILE}"

		echo -e "[${idx}] JOB=${job} ======== START: $(date) LOG_FILE: ${LOG_FILE}" 2>&1 | tee ${TMP_LOGFILE}
		build ${idx} ${job}
		echo -e "[${idx}] JOB=${job} ======== END: $(date)" 2>&1 | tee -a ${TMP_LOGFILE}
		mv ${TMP_LOGFILE} ${LOG_PATH}

		sleep ${INTERVAL}
	done
done

if [[ ! -z "${DEBUG}" ]] ; then
	ls -lh ${LOG_PATH}
fi

LOG_FILES=$(find ${LOG_PATH} -name "build-*" -print0 | sort -z | xargs -r0 ls)
echo -e "# AOSP Build Test Summary\n" 2>&1 | tee ${SUMMARY_FILE}
echo -e "Tested at $(date)\n" 2>&1 | tee -a ${SUMMARY_FILE}

echo -e "##Test configration\n" 2>&1 | tee -a ${SUMMARY_FILE}
echo -e "- SRC_PATH: \`${SOURCE_TOP}\`" >> ${SUMMARY_FILE}
echo -e "- BOARD_CFG: \`${BOARD_CFG}\`" >> ${SUMMARY_FILE}
echo -e "- LOG_PATH: \`${LOG_PATH}\`" >> ${SUMMARY_FILE}
echo -e "- HOSTNAME: \`${HOSTNAME}\`" >> ${SUMMARY_FILE}
echo -e "- PREFIX: \`${PREFIX}\`" >> ${SUMMARY_FILE}
echo -e "- JOBS_LIST: \`${JOBS_LIST}\`" >> ${SUMMARY_FILE}
echo -e "- TIMES: ${TIMES}" >> ${SUMMARY_FILE}
echo -e "- INTERVAL: ${INTERVAL} seconds" >> ${SUMMARY_FILE}

for LOG_FILE in ${LOG_FILES}
do
	echo -e "\nLOG_FILE: ${LOG_FILE}" 2>&1 | tee -a ${SUMMARY_FILE}

	if [[ ! -z "${DEBUG}" ]] ; then
		grep "Testing START" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE}
		grep "Testing END" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE}

		continue
	fi

	grep "Cleaning START" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE}
	grep "Configure START" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE}
	grep "Build START" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE}
	tail -n 20 ${LOG_FILE} | grep successful 2>&1 | tee -a ${SUMMARY_FILE}
	grep "Build END" ${LOG_FILE} 2>&1 | tee -a ${SUMMARY_FILE}
done

exit 0
