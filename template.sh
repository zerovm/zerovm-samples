#!/bin/bash

if [ $# -lt 1 ]
then
	echo "Expected path to template file"
	exit
fi

if [ "$MEMORY" == "" ]
then
    MEMORY=4294967295
fi

if [ "$CHANNELS_INCLUDE" != "" ]
then
    TEMPFILE=$CHANNELS_INCLUDE.temp
    TEMPLATE=$CHANNELS_INCLUDE.temp
awk -v inclfile=$CHANNELS_INCLUDE '
    /{CHANNELS_INCLUDE}/ {system("cat " inclfile); next}
    {print}' $1 > $TEMPLATE
else
    TEMPLATE=$1
fi

sed s@{ABS_PATH}@$ABS_PATH/@g $TEMPLATE | \
sed s@{NAME}@$NAME@g | \
sed s@{MEMORY}@$MEMORY@g | \
sed s@{SECONDS}@$SECONDS@ | \
sed s@{NODEID}@$NODEID@ | \
sed s@{TIMEOUT}@$TIMEOUT@ | \
sed s@{SEQUENTIAL_ID}@$SEQUENTIAL_ID@ | \
sed s@{VERBOSITY}@$VERBOSITY@ | \
sed s@{JOB}@$JOB@ | \
sed s@{NEXE_PATH}@$NEXE_PATH@ | \
sed s@{CHANNELS_INCLUDE}@@ 

rm -f $TEMPFILE



