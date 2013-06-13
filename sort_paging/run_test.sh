#!/bin/bash
source ../run.env
./genmanifest.sh
echo ---------------------------------------------------- generating
time ${SETARCH} ${ZEROVM} -Mmanifest/generator.manifest -v2
cat generator.stderr.log
echo ---------------------------------------------------- sorting
time ${SETARCH} ${ZEROVM} -Mmanifest/sort.manifest -v2
cat sort.stderr.log
echo ---------------------------------------------------- testing
${SETARCH} ${ZEROVM} -Mmanifest/test.manifest -v2
cat test.stderr.log

