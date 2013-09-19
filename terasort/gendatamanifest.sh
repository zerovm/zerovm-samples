#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=`dirname "$SCRIPT"`

SINGLE_NODE_INPUT_RECORDS_COUNT=5000000

#Generate from template
MAP_FIRST=1
MAP_LAST=4
REDUCE_FIRST=1
REDUCE_LAST=4

DATA_OFFSET=0
SEQUENTIAL_ID=1

echo "Generating input data"

#create manifest, nvram files for mapper
#do relace and delete self communication map channels
COUNTER=$MAP_FIRST
while [  $COUNTER -le $MAP_LAST ]; do
#genmanifest
    NAME=map \
    MEMORY=4294967296 \
    TIMEOUT=500 \
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
#gendata run under host os
    echo ./gensort -c -t4 -s -b$DATA_OFFSET -a $SINGLE_NODE_INPUT_RECORDS_COUNT data/"$COUNTER"input.txt 2> data/"$COUNTER"source.sum
    ./gensort -c -t4 -s -b$DATA_OFFSET -a $SINGLE_NODE_INPUT_RECORDS_COUNT data/"$COUNTER"input.txt 2> data/"$COUNTER"source.sum
#increment
    let SEQUENTIAL_ID=SEQUENTIAL_ID+1
    let COUNTER=COUNTER+1 
    let DATA_OFFSET=DATA_OFFSET+SINGLE_NODE_INPUT_RECORDS_COUNT
done

#create manifest, nvram files for reducer and valsort
COUNTER=$REDUCE_FIRST
while [  $COUNTER -le $REDUCE_LAST ]; do
#genmanifest reducer
    NAME=reduce \
    MEMORY=4294967296 \
    TIMEOUT=500 \
    NODEID=$COUNTER \
    ABS_PATH=$SCRIPT_PATH \
    CHANNELS_INCLUDE=manifest/reduce.channels.manifest.include \
    SEQUENTIAL_ID=$SEQUENTIAL_ID \
    ../template.sh ../manifest.template | \
    sed s@r_red"$COUNTER"-@/dev/in/@g > manifest/reduce"$COUNTER".manifest
#gennvram reducer
    NODEID=$COUNTER \
    ../template.sh nvram/reduce.nvram.template > nvram/reduce"$COUNTER".nvram
#genmanifest valsort
    NAME=valsort \
    MEMORY=4294967296 \
    TIMEOUT=100 \
    NODEID=$COUNTER \
    ABS_PATH=$SCRIPT_PATH \
    CHANNELS_INCLUDE=manifest/valsort.channels.manifest.include \
    ../template.sh ../manifest.template > manifest/valsort"$COUNTER".manifest
#gennvram valsort
    VERBOSITY=1 \
    ../template.sh nvram/valsort.nvram.template | \
    sed s@{NODES_COUNT}@$REDUCE_LAST@g  > nvram/valsort"$COUNTER".nvram
#increment loop vars
    let SEQUENTIAL_ID=SEQUENTIAL_ID+1
    let COUNTER=COUNTER+1 
done


