#!/bin/bash
date
old_time=`date +%Y%m%d%H%M%S`
old_time_for_insert=`date '+%Y-%m-%d %H:%M:%S'`
ntpdate -b time.bora.net
set_time_first=`date +%Y%m%d%H%M%S`
if [ $set_time_first -lt $old_time ]; then
ntpdate -b ntp2.epidc.co.kr
#time.bora.net #kriss.re.kr   
fi
set_time_second=`date +%Y%m%d%H%M%S`
if [ $set_time_first -lt $old_time ]; then
ntpdate -b "$old_time_for_insert" #       
fi
date
