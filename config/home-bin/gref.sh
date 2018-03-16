#!/bin/sh

if [ $# = 1 ]
then
        dir=.
else if [ $# = 2 ]
then
        dir=$2
else
        echo "USAGE: gref patten [path]"
        exit 1
fi
fi

find $dir -type f -exec grep --color=auto -l "$1" {} \; \
   -exec grep --color=auto -n "$1" {} \; \
   -exec echo " " \;

