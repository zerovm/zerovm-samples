#!/bin/bash
source ../run.env
echo Run sqlite samples

#open database mounted into read-only channel
READ_ONLY_INPUT_CHANNEL=sqlite/data/test_sqlite.db

#use /dev/tarimage channel and real tar archive will be mounted
TAR_IMAGE=mounts/tarfs.tar

DATA_FILE=$READ_ONLY_INPUT_CHANNEL \
./sqlite/sqlite.sh sqlite/scripts/select.sql "/dev/input ro"

DATA_FILE=$TAR_IMAGE
./sqlite/sqlite.sh sqlite/scripts/select_clone.sql "/sqlite.db rw"

./sqlite/sqlite.sh sqlite/scripts/create_insert_select.sql "/sqlite-new.db rw"

rm -f sqlite/data/test_sqlite.db
DATA_FILE=sqlite/data/test_sqlite.db \
./sqlite/sqlite-cdr.sh sqlite/scripts/insert_select_cdr.sql "/dev/cdr rw"