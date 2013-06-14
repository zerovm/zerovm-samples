#!/bin/bash
source ../run.env

SCRIPT_PATH_ON_REAL_FS="$1"
OUTPUT_FILE="$1".stdout
LOG_FILE="$1".stderr.log
COMMAND_LINE="$2 $3 $4 $5 $6 $7"
NEW_MANIFEST="$1".manifest

MANIFEST=manifest/sqlite.channels.manifest.include \
NVRAM_TEMPLATE=nvram/sqlite.nvram.template \
NVRAM="$1".nvram \
./genmanifest.sh \
${SCRIPT_PATH_ON_REAL_FS} \
${OUTPUT_FILE} \
"${DATA_FILE}" \
${LOG_FILE} \
"${COMMAND_LINE}" > ${NEW_MANIFEST}
echo ------------run ${NEW_MANIFEST}
rm ${OUTPUT_FILE} -f
echo ${ZEROVM} -M${NEW_MANIFEST}
${ZEROVM} -M${NEW_MANIFEST}
echo "stdout output >>>>>>>>>>"
cat ${OUTPUT_FILE}
echo "stderr output >>>>>>>>>>"
cat ${LOG_FILE}
