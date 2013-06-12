#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=`dirname "$SCRIPT"`

#Generate from template

TIMEOUT=20 \
ABS_PATH=$SCRIPT_PATH \
NAME=reqrep \
SEQUENTIAL_ID=1 \
CHANNELS_INCLUDE=manifest/test1.channels.manifest.include \
../template.sh ../manifest.template > manifest/test1.manifest

TIMEOUT=20 \
ABS_PATH=$SCRIPT_PATH \
NAME=reqrep \
SEQUENTIAL_ID=1 \
CHANNELS_INCLUDE=manifest/test1-mode2.channels.manifest.include \
../template.sh ../manifest.template > manifest/test1-mode2.manifest

TIMEOUT=20 \
ABS_PATH=$SCRIPT_PATH \
NAME=reqrep \
SEQUENTIAL_ID=2 \
CHANNELS_INCLUDE=manifest/test2.channels.manifest.include \
../template.sh ../manifest.template > manifest/test2.manifest

TIMEOUT=20 \
ABS_PATH=$SCRIPT_PATH \
NAME=reqrep \
SEQUENTIAL_ID=2 \
CHANNELS_INCLUDE=manifest/test2-mode2.channels.manifest.include \
../template.sh ../manifest.template > manifest/test2-mode2.manifest
