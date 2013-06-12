#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=`dirname "$SCRIPT"`

#Generate from template manifests, nvram files
SRC_FIRST=1
SRC_LAST=10
DST_FIRST=1
DST_LAST=10

SEQUENTIAL_ID=1

NAME=nodeman \
NODEID=$COUNTER \
TIMEOUT=100 \
ABS_PATH=$SCRIPT_PATH \
SEQUENTIAL_ID=$SEQUENTIAL_ID \
CHANNELS_INCLUDE=${SCRIPT_PATH}/manifest/sortman.manifest.include \
../template.sh ../manifest.template | \
sed s@r_man"$COUNTER"-@/dev/in/@g > manifest/sortman.manifest 
cp nvram/sortman.nvram.template nvram/sortman.nvram

COUNTER=$SRC_FIRST
while [  $COUNTER -le $SRC_LAST ]; do
    NAME=generator.uint32_t \
    TIMEOUT=10 \
    NODEID=$COUNTER \
    ABS_PATH=$SCRIPT_PATH \
    CHANNELS_INCLUDE=${SCRIPT_PATH}/manifest/generator.manifest.include \
    ../template.sh ../manifest.template > manifest/generator"$COUNTER".manifest
    cp nvram/generator.nvram.template nvram/generator.nvram

    let SEQUENTIAL_ID=SEQUENTIAL_ID+1
#generate manifest
    NAME=nodesrc \
    TIMEOUT=100 \
    NODEID=$COUNTER \
    ABS_PATH=$SCRIPT_PATH \
    SEQUENTIAL_ID=$SEQUENTIAL_ID \
    CHANNELS_INCLUDE=${SCRIPT_PATH}/manifest/sortsrc.manifest.include \
    ../template.sh ../manifest.template | \
    sed /src"$COUNTER"-src"$COUNTER"/d > manifest/sortsrc"$COUNTER".manifest
#generate nvram
    NODEID=$COUNTER \
    ../template.sh nvram/sortsrc.nvram.template > nvram/"$COUNTER"sortsrc.nvram
    let COUNTER=COUNTER+1 
done

COUNTER=$DST_FIRST
while [  $COUNTER -le $DST_LAST ]; do
    let SEQUENTIAL_ID=SEQUENTIAL_ID+1
#generate manifest
    NAME=nodedst \
    TIMEOUT=100 \
    NODEID=$COUNTER \
    ABS_PATH=$SCRIPT_PATH \
    SEQUENTIAL_ID=$SEQUENTIAL_ID \
    CHANNELS_INCLUDE=${SCRIPT_PATH}/manifest/sortdst.manifest.include \
    ../template.sh ../manifest.template > manifest/sortdst"$COUNTER".manifest
#generate nvram
    NODEID=$COUNTER \
    SEQUENTIAL_ID=$SEQUENTIAL_ID \
    ../template.sh nvram/sortdst.nvram.template > nvram/"$COUNTER"sortdst.nvram
    let COUNTER=COUNTER+1 
done
