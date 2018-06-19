#!/bin/sh

HELP()
{
	echo "## Usage: $0 [ -m mode -s tx_strength | -f frequency | -d duration | -v ]"
	echo "          -m: mode( 1: TX only, 2: RX only )"
	echo "          -s: tx_strenth( 0 ~ 63 )"
	echo "          -f: frequency( 1 ~ 5 )"
	echo "          -d: duration for test timer( 1000 ~ )"
	echo "          -v: verbose output"
	exit 1;
}

OPTSPEC="hvm:s:f:"

while getopts $OPTSPEC  opt ; do
	case $opt in
		m )
			echo "opt: $opt OPTARG: $OPTARG"
			mode=$OPTARG
			;;
		s )
			echo "opt: $opt OPTARG: $OPTARG"
			strenth=$OPTARG
			;;
		f )
			echo "opt: $opt OPTARG: $OPTARG"
			frequency=$OPTARG
			;;
		d )
			echo "opt: $opt OPTARG: $OPTARG"
			duration=$OPTARG
			;;
		h )
			HELP
			;;
		v )
			echo "opt: $opt OPTARG: $OPTARG"
			echo "Verbose: $OPTARG"
			;;
		\? )
			echo "Invalid option $opt"
			HELP
			;;
	esac
done

