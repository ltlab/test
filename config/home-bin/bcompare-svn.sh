#!/bin/bash
echo -e "1=$1 2=$2 3=$3 4=$4 5=$5 6=$6 7=$7 8=$8"

bcompare "$6" "$7" -title1="$3" -title2="$5" & # -readonly

exit 0

