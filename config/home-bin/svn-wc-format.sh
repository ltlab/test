#!/bin/sh

if [ -z $1 ] || [ "$1" = "-h" ] ; then
    echo "## Usage:  $0 [ SVN_VERSION | -h ]"
	exit 0;
fi

change-svn-wc-format.py ./ $1 --verbose



