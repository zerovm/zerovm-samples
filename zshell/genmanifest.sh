#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=`dirname "$SCRIPT"`

VAR_NAME_1={SCRIPT_FILE_PATH}
VAR_NAME_2={OUTPUT_FILE_PATH}
VAR_NAME_3={DATA_FILE_PATH}
VAR_NAME_4={LOG_FILE_PATH}
VAR_NAME_5={COMMAND_LINE}

if [ $# -lt 2 ]
then
    echo Error: At least 3 parameters required : 1-script file name, 2-output file name, 3-data file name;
    echo Info: Optional parameters : 4-log filename, 5-"commandline string"
  exit
fi

JOB_NAME=`basename "$1"`

if [[ "$3" == "/dev/null" ]] || [[ "$3" == "" ]]
then
    SED_3=s@$VAR_NAME_3@/dev/null@g
else
    SED_3=s@$VAR_NAME_3@$SCRIPT_PATH/$3@g    
fi

if [[ "$4" == "/dev/null" ]] || [[ "$4" == "" ]]
then
    SED_4=s@$VAR_NAME_4@/dev/null@g
else
    SED_4=s@$VAR_NAME_4@$SCRIPT_PATH/$4@g    
fi

#write into nvram
sed s@$VAR_NAME_5@"$5"@ $NVRAM_TEMPLATE > $NVRAM

#Generate manifest as output from template
TIMEOUT=100 \
ABS_PATH=$SCRIPT_PATH \
NAME=zshell \
CHANNELS_INCLUDE=$MANIFEST \
../template.sh ../manifest.template | \
sed s@$VAR_NAME_1@$SCRIPT_PATH/$1@g | \
sed s@$VAR_NAME_2@$SCRIPT_PATH/$2@g | \
sed $SED_3 | \
sed $SED_4 | \
sed s@{ABS_PATH}@$SCRIPT_PATH/@ | \
sed s@{DEBUG_FILE_PATH}@$SCRIPT_PATH/log/$JOB_NAME.zrt.log@g
