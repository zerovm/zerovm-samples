#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=`dirname "$SCRIPT"`

#Generate from template
MAP_FIRST=1
MAP_LAST=4
REDUCE_FIRST=1
REDUCE_LAST=5

SEQUENTIAL_ID=1

#do relace and delete self communication map channels
COUNTER=$MAP_FIRST
while [  $COUNTER -le $MAP_LAST ]; do
#genmanifest
    NAME=map \
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
    let SEQUENTIAL_ID=SEQUENTIAL_ID+1
    let COUNTER=COUNTER+1 
done

COUNTER=$REDUCE_FIRST
while [  $COUNTER -le $REDUCE_LAST ]; do
#genmanifest
    NAME=reduce \
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


