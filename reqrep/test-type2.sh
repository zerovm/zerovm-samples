#!/bin/bash
source ../run.env

../ns_start.sh 2

${SETARCH} ${ZEROVM} -Mmanifest/test1-mode2.manifest -v10 &
${SETARCH} ${ZEROVM} -Mmanifest/test2-mode2.manifest -v10

sleep 1
echo "############### test 1 #################"
cat log/1stderr.log
echo "############### test 2 #################"
cat log/2stderr.log

../ns_stop.sh

