#!/bin/bash

if [ $# -lt 2 ] || [ $# -gt 4 ]; then
	echo "Usage: $0 _TIMEOUT_SIGINT _TIMEOUT_SIGTERM [input] [output]"
	echo ""
	echo "  _TIMEOUT_SIGINT in seconds"
	echo "  _TIMEOUT_SIGTERM in seconds"
	echo "  input file. default=/opt/ros/kinetic/lib/python2.7/dist-packages/roslaunch/nodeprocess.py"
	echo "  output file. default=input"
	exit
fi

SIGINT=$1
SIGTERM=$2

if [ $# -gt 2 ]; then
	INPUT=$3
else
	INPUT=/opt/ros/kinetic/lib/python2.7/dist-packages/roslaunch/nodeprocess.py
fi

if [ $# -gt 3 ]; then
	OUTPUT=$4
else
	OUTPUT=$INPUT
fi

sed "s/_TIMEOUT_SIGINT[ ]*=[ ]*[0-9]*.[0-9]/_TIMEOUT_SIGINT = $SIGINT/g" $INPUT | \
sed "s/_TIMEOUT_SIGTERM[ ]*=[ ]*[0-9]*.[0-9]/_TIMEOUT_SIGTERM = $SIGTERM/g" > .tmp123abc
rm -rf $OUTPUT
mv .tmp123abc $OUTPUT

