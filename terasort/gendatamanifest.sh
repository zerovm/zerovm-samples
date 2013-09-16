#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=`dirname "$SCRIPT"`
echo $SCRIPT_PATH 

SINGLE_NODE_INPUT_RECORDS_COUNT=1000000

#Generate from template
MAP_FIRST=1
MAP_LAST=4
REDUCE_FIRST=1
REDUCE_LAST=4

DATA_OFFSET=0
SEQUENTIAL_ID=1

#do relace and delete self communication map channels
COUNTER=$MAP_FIRST
while [  $COUNTER -le $MAP_LAST ]; do
#genmanifest
    NAME=map \
    MEMORY=4294967296 \
    TIMEOUT=100 \
    NODEID=$COUNTER \
    ABS_PATH=$SCRIPT_PATH \
    CHANNELS_INCLUDE=manifest/map.channels.manifest.include \
    SEQUENTIAL_ID=$SEQUENTIAL_ID \
    ../template.sh ../manifest.template | \
    sed /map"$COUNTER"-map-"$COUNTER"/d | \
    sed s@w_map"$COUNTER"-@/dev/out/@g | \
    sed s@r_map"$COUNTER"-@/dev/in/@g > manifest/map"$COUNTER".manifest 
#gennvram
    NODEID=$COUNTER \
    ../template.sh nvram/map.nvram.template > nvram/map"$COUNTER".nvram
#gendata
    ./gensort -c -t4 -s -b$DATA_OFFSET -a $SINGLE_NODE_INPUT_RECORDS_COUNT data/"$COUNTER"input.txt 2> data/"$COUNTER"source.sum
#increment
    let SEQUENTIAL_ID=SEQUENTIAL_ID+1
    let COUNTER=COUNTER+1 
    let DATA_OFFSET=DATA_OFFSET+SINGLE_NODE_INPUT_RECORDS_COUNT
done

COUNTER=$REDUCE_FIRST
while [  $COUNTER -le $REDUCE_LAST ]; do
#genmanifest
    NAME=reduce \
    MEMORY=4294967296 \
    TIMEOUT=100 \
    NODEID=$COUNTER \
    ABS_PATH=$SCRIPT_PATH \
    CHANNELS_INCLUDE=manifest/reduce.channels.manifest.include \
    SEQUENTIAL_ID=$SEQUENTIAL_ID \
    ../template.sh ../manifest.template | \
    sed s@r_red"$COUNTER"-@/dev/in/@g > manifest/reduce"$COUNTER".manifest
#gennvram
    NODEID=$COUNTER \
    ../template.sh nvram/reduce.nvram.template > nvram/reduce"$COUNTER".nvram
    let SEQUENTIAL_ID=SEQUENTIAL_ID+1
    let COUNTER=COUNTER+1 
done


