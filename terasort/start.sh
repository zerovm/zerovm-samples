#!/bin/bash
source ../run.env

rm data/*.dat -f
rm log/* -f

ZVM_REPORT=report.txt
ZEROVM=$ZVM_PREFIX/bin/zerovm

#config for mapreduce network
MAP_FIRST=1
MAP_LAST=4
REDUCE_FIRST=1
REDUCE_LAST=4

#calculate number of nodes for whole cluster
let NUMBER_OF_NODES=${MAP_LAST}+${REDUCE_LAST}

echo "Start sorting job"

../ns_start.sh ${NUMBER_OF_NODES}

rm ${ZVM_REPORT} -f

COUNTER=$MAP_FIRST
while [  $COUNTER -le $MAP_LAST ]; do
    echo ${ZEROVM} -Mmanifest/map$COUNTER.manifest
    ${ZEROVM} -Mmanifest/map$COUNTER.manifest >> ${ZVM_REPORT} &
    let COUNTER=COUNTER+1 
done

COUNTER=$REDUCE_FIRST
#run all reduce nodes
while [  $COUNTER -le $REDUCE_LAST ]; do
    echo ${ZEROVM} -Mmanifest/reduce$COUNTER.manifest
    ${ZEROVM} -Mmanifest/reduce$COUNTER.manifest >> ${ZVM_REPORT} &
    let COUNTER=COUNTER+1 
done

for job in `jobs -p`
do
    wait $job
done

../ns_stop.sh
cat ${ZVM_REPORT}

echo "Start examining results"
#test results
rm data/temp.sum -f
COUNTER=1
while [  $COUNTER -le $REDUCE_LAST ]; do
    ${ZEROVM} -Mmanifest/valsort$COUNTER.manifest
    cat log/valsort$COUNTER.stderr.log
    let COUNTER=COUNTER+1 
done
