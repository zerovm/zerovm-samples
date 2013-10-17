include ../Makefile.env
NAME=fork

CFLAGS+=-g2

#fork.c sample will check file contents after tar mount during runtime
#file path it should get from envvar=FPATH
TESTPATH=.
TESTFILE=${NAME}test
TARNAME=${NAME}

TRACE=${CURDIR}/${NAME}.trace
SOCK:= $(shell mktemp)

all: prepare fork1 fork2 finish

fork1: $(NAME).o
	$(CC) -o $(NAME).nexe $(NAME).o $(LDFLAGS)
#genmanifest
	@JOB=Job=${SOCK} \
	TIMEOUT=10 \
	ABS_PATH=$(CURDIR) \
	NAME=$(NAME) \
	CHANNELS_INCLUDE=channels.manifest.include \
	../template.sh ../manifest.template > $(NAME).manifest
#gennvram
	@VERBOSITY=4 \
	../template.sh ../nvram.template  > $(NAME).nvram
	@echo "[env]" >> $(NAME).nvram
	@echo "name=FPATH, value=${TESTPATH}/${TESTFILE}" >> $(NAME).nvram
	@echo "[fstab]" >> $(NAME).nvram
	@echo "channel=/dev/tar, mountpoint=/, access=ro, removable=yes" >> $(NAME).nvram
#launch sample which can call zfork
	@rm -f ${TRACE} ${SOCK}
	@echo "run sample want to fork"
	$(ZEROVM) -M$(NAME).manifest
#-T ${TRACE}
	cat $(NAME).stdout.log
#overwrite tar contents
	@rm -f ${TESTPATH}/${TARNAME}.tar
	@cp ${TESTPATH}/${TARNAME}2.tar ${TESTPATH}/${TARNAME}.tar
#launch forked sample
	@echo "run forked sample"
	@cat $(NAME).manifest | python daemon_client.py ${SOCK}
	cat $(NAME).stdout.log
	@rm -f ${TRACE} ${SOCK}

$(NAME)2: SOCK:= $(shell mktemp)
$(NAME)2: empty.o
	@echo "=================================="
	$(CC) -o $(NAME)2.nexe empty.o $(LDFLAGS)
#genmanifest
	@JOB=Job=${SOCK} \
	TIMEOUT=10 \
	ABS_PATH=$(CURDIR) \
	NAME=$(NAME)2 \
	CHANNELS_INCLUDE=channels.manifest.include \
	../template.sh ../manifest.template > $(NAME)2.manifest
#gennvram
	@VERBOSITY=4 \
	../template.sh ../nvram.template  > $(NAME)2.nvram
	@echo "[precache]" >> $(NAME)2.nvram
	@echo "precache=yes" >> $(NAME)2.nvram
	@echo "[fstab]" >> $(NAME)2.nvram
	@echo "channel=/dev/tar, mountpoint=/, access=ro, removable=yes" >> $(NAME)2.nvram
#launch sample which can call zfork inside zrt
	@rm -f ${TRACE} ${SOCK}
	@echo "run fork2 sample"
	$(ZEROVM) -M$(NAME)2.manifest
#-T ${TRACE}
	cat $(NAME)2.stdout.log
#overwrite tar contents
	@rm -f ${TESTPATH}/${TARNAME}.tar
	@cp ${TESTPATH}/${TARNAME}2.tar ${TESTPATH}/${TARNAME}.tar
#launch forked sample
	@echo "run forked sample fork2"
	@cat $(NAME)2.manifest | python daemon_client.py ${SOCK}
	cat $(NAME)2.stdout.log
	@rm -f ${TRACE} ${SOCK}
	@pgrep -f $(NAME)2.manifest | xargs kill -9

finish:
	@pgrep -f ${NAME}.manifest | xargs kill -9
	@pgrep -f ${NAME}2.manifest | xargs kill -9

prepare:
	chmod u+rwx ../template.sh
	@rm -f ${TESTPATH}/${TARNAME}.tar ${TESTPATH}/${TARNAME}2.tar ${TESTPATH}/${TESTFILE}
	@echo "mount" > ${TESTPATH}/${TESTFILE}
	@tar -cf ${TESTPATH}/${TARNAME}.tar ${TESTPATH}/${TESTFILE}
	@echo "remount" > ${TESTPATH}/${TESTFILE}
	@tar -cf ${TESTPATH}/${TARNAME}2.tar ${TESTPATH}/${TESTFILE}
	@rm -f ${TESTPATH}/${TESTFILE}

clean:
	@rm -f *.nexe *.manifest *.nvram *.o *.log *.data *.scp *.null *.tar
