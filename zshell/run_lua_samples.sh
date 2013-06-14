#!/bin/bash
source ../run.env

./lua/lua.sh lua/scripts/hello.lua

DATA_FILE=lua/scripts/280x.png \
./lua/lua.sh lua/scripts/pngparse.lua /dev/input

./lua/lua.sh lua/scripts/command_line.lua var1 var2 var3
