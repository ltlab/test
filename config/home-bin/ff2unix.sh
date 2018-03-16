#!/bin/sh

if [ -z $1 ] ; then
	echo "## Usage: $0 [file_expression]"
	echo "   ex) $0 .c"
	exit 0;
else
	echo "find `pwd` -name "*$1" -exec vim -c "set ff=unix" -c "wq" {} \;"
	find `pwd` -name "*$1" -exec vim -c "set ff=unix" -c "wq" {} \;
fi

