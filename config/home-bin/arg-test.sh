#!/bin/sh

ARG_LIST=$*

echo "ARG: $ARG_LIST"

OPTION="NONE"

for arg in $ARG_LIST
do
	case $arg in
		-h )
			echo "CHANGE: $OPTION => HELP / ARG $arg"
			OPTION="HELP"
			;;
		-p )
			echo "CHANGE: $OPTION => PRINT / ARG $arg"
			OPTION="PRINT"
			;;
		* )
			echo "OPTION: $OPTION / ARG: $arg"
	esac
done
