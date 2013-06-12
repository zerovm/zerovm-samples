#!/bin/bash
source ../run.env

./gendata.sh

../ns_start.sh 21

ZVM_VERBOSITY=-v2

#config for 10src, 10dst nodes
SRC_FIRST=1
SRC_LAST=10
DST_FIRST=1
DST_LAST=10

COUNTER=$SRC_FIRST
while [  $COUNTER -le $SRC_LAST ]; do
    ${SETARCH} ${ZEROVM} -Mmanifest/sortsrc"$COUNTER".manifest ${ZVM_VERBOSITY} \
	> log/zerovm.sortsrc"$COUNTER".log &
    let COUNTER=COUNTER+1 
done

COUNTER=$DST_FIRST
while [  $COUNTER -le $DST_LAST ]; do
    ${SETARCH} ${ZEROVM} -Mmanifest/sortdst"$COUNTER".manifest ${ZVM_VERBOSITY} \
	> log/zerovm.sortdst"$COUNTER".log &
    let COUNTER=COUNTER+1 
done

date > /tmp/time
${SETARCH} ${ZEROVM} -Mmanifest/sortman.manifest ${ZVM_VERBOSITY}
date >> /tmp/time

cat log/sortman.stderr.log
echo Manager node working time: 
cat /tmp/time

../ns_stop.sh
