#!/bin/bash
echo -e "1=$1 2=$2 3=$3 4=$4 5=$5 6=$6 7=$7 8=$8 9=$9 10=${10} 11=${11}"

MINE = ${9}
OLDER = ${10}
YOURS = ${11}

bcompare --older $OLDER --mine="$MINE" --yours="$YOURS"

exit 0

