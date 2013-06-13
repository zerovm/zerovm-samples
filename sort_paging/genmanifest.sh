#!/bin/bash

SCRIPT=$(readlink -f "$0")
CURDIR=`dirname "$SCRIPT"`

#genmanifest
NAME=generator.uint32_t
TIMEOUT=20 \
CHANNELS_INCLUDE=manifest/generator.channels.manifest.include \
ABS_PATH=$CURDIR \
NAME=$NAME \
../template.sh ../manifest.template > manifest/generator.manifest

#genmanifest
NAME=sort_uint_proper_with_args
TIMEOUT=20 \
CHANNELS_INCLUDE=manifest/sort.channels.manifest.include \
ABS_PATH=$CURDIR \
NAME=$NAME \
../template.sh ../manifest.template > manifest/sort.manifest

#genmanifest
NAME=tester.uint32_t
TIMEOUT=20 \
CHANNELS_INCLUDE=manifest/test.channels.manifest.include \
ABS_PATH=$CURDIR \
NAME=$NAME \
../template.sh ../manifest.template > manifest/test.manifest

