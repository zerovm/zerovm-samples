#!/bin/bash
source config

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=`dirname "$SCRIPT"`

#Generate from template
MAP_TEMPLATE=manifest/map.channels.manifest.include
MAP_W_MAP_TEMPLATE=manifest/template/map_w_map.channels.manifest.include
MAP_R_MAP_TEMPLATE=manifest/template/map_r_map.channels.manifest.include
MAP_W_RED_TEMPLATE=manifest/template/map_w_red.channels.manifest.include

REDUCE_TEMPLATE=manifest/reduce.channels.manifest.include
RED_R_MAP_TEMPLATE=manifest/template/red_r_map.channels.manifest.include

TEMP_MAP_TEMPLATE=`mktemp -u`
TEMP_MAP_W_MAP_TEMPLATE=`mktemp -u`
TEMP_MAP_R_MAP_TEMPLATE=`mktemp -u`
TEMP_MAP_W_RED_TEMPLATE=`mktemp -u`
TEMP_REDUCE_TEMPLATE=`mktemp -u`
TEMP_RED_R_MAP_TEMPLATE=`mktemp -u`

SEQUENTIAL_ID=1
MAP_PORT_COUNTER=1
REDUCE_PORT_COUNTER=1

###############################################
##### prepare manifest/nvram for map nodes ####
###############################################

#generate map_w_map file for map nodes
MAP_COUNTER=$MAP_FIRST
while [  $MAP_COUNTER -le $MAP_LAST ]; do
    sed s@{PORT_COUNTER}@$MAP_PORT_COUNTER@ $MAP_W_MAP_TEMPLATE | \
    sed s@{MAP_COUNTER}@$MAP_COUNTER@ >> $TEMP_MAP_W_MAP_TEMPLATE
    let MAP_PORT_COUNTER=MAP_PORT_COUNTER+1 
    let MAP_COUNTER=MAP_COUNTER+1
done

#generate map_r_map file for map nodes
MAP_PORT_COUNTER=1
MAP_COUNTER=$MAP_FIRST
while [  $MAP_COUNTER -le $MAP_LAST ]; do
    sed s@{PORT_COUNTER}@$MAP_PORT_COUNTER@ $MAP_R_MAP_TEMPLATE | \
    sed s@{MAP_COUNTER}@$MAP_COUNTER@ >> $TEMP_MAP_R_MAP_TEMPLATE
    let MAP_PORT_COUNTER=MAP_PORT_COUNTER+1 
    let MAP_COUNTER=MAP_COUNTER+1
done

#generate map_w_red file for map nodes
REDUCE_COUNTER=$REDUCE_FIRST
while [  $REDUCE_COUNTER -le $REDUCE_LAST ]; do
    sed s@{PORT_COUNTER}@$MAP_PORT_COUNTER@ $MAP_W_RED_TEMPLATE | \
    sed s@{RED_COUNTER}@$REDUCE_COUNTER@ >> $TEMP_MAP_W_RED_TEMPLATE
    let MAP_PORT_COUNTER=MAP_PORT_COUNTER+1 
    let REDUCE_COUNTER=REDUCE_COUNTER+1
done

#add channels into template
awk -v inclfile_map_w_map=$TEMP_MAP_W_MAP_TEMPLATE \
    -v inclfile_map_r_map=$TEMP_MAP_R_MAP_TEMPLATE \
    -v inclfile_map_w_red=$TEMP_MAP_W_RED_TEMPLATE \ '
    /{MAP_W_MAP_CHANNELS}/ {system("cat " inclfile_map_w_map); next}
    /{MAP_R_MAP_CHANNELS}/  {system("cat " inclfile_map_r_map); next}
    /{MAP_W_RED_CHANNELS}/  {system("cat " inclfile_map_w_red); next}
    {print}' $MAP_TEMPLATE > $TEMP_MAP_TEMPLATE

#do replace and delete self communication map channels
COUNTER=$MAP_FIRST
while [  $COUNTER -le $MAP_LAST ]; do
#genmanifest
    NAME=map \
    TIMEOUT=100 \
    NODEID=$COUNTER \
    ABS_PATH=$SCRIPT_PATH \
    CHANNELS_INCLUDE=$TEMP_MAP_TEMPLATE \
    SEQUENTIAL_ID=$SEQUENTIAL_ID \
    ../template.sh ../manifest.template | \
    sed /map"$COUNTER"-map-"$COUNTER",/d | \
    sed s@w_map"$COUNTER"-@/dev/out/@g | \
    sed s@r_map"$COUNTER"-@/dev/in/@g > manifest/map"$COUNTER".manifest 
#gennvram
    NODEID=$COUNTER \
    ../template.sh nvram/map.nvram.template > nvram/map"$COUNTER".nvram
    let SEQUENTIAL_ID=SEQUENTIAL_ID+1
    let COUNTER=COUNTER+1 
done


##################################################
##### prepare manifest/nvram for reduce nodes ####
##################################################

#generate map_w_red file for map nodes
MAP_COUNTER=$MAP_FIRST
while [  $MAP_COUNTER -le $MAP_LAST ]; do
    sed s@{PORT_COUNTER}@$REDUCE_PORT_COUNTER@ $RED_R_MAP_TEMPLATE | \
    sed s@{MAP_COUNTER}@$MAP_COUNTER@ >> $TEMP_RED_R_MAP_TEMPLATE
    let REDUCE_PORT_COUNTER=REDUCE_PORT_COUNTER+1 
    let MAP_COUNTER=MAP_COUNTER+1
done

#add channels into template
awk -v inclfile_red_r_map=$TEMP_RED_R_MAP_TEMPLATE \ '
    /{RED_R_MAP_CHANNELS}/  {system("cat " inclfile_red_r_map); next}
    {print}' $REDUCE_TEMPLATE > $TEMP_REDUCE_TEMPLATE

COUNTER=$REDUCE_FIRST
while [  $COUNTER -le $REDUCE_LAST ]; do
#genmanifest
    NAME=reduce \
    TIMEOUT=100 \
    NODEID=$COUNTER \
    ABS_PATH=$SCRIPT_PATH \
    CHANNELS_INCLUDE=$TEMP_REDUCE_TEMPLATE \
    SEQUENTIAL_ID=$SEQUENTIAL_ID \
    ../template.sh ../manifest.template | \
    sed s@r_red"$COUNTER"-@/dev/in/@g > manifest/reduce"$COUNTER".manifest
#gennvram
    NODEID=$COUNTER \
    ../template.sh nvram/reduce.nvram.template > nvram/reduce"$COUNTER".nvram
    let SEQUENTIAL_ID=SEQUENTIAL_ID+1
    let COUNTER=COUNTER+1 
done


