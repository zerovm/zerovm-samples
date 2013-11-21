include ../Makefile.env
NAME=hello

CFLAGS+=-g2

all: prepare $(NAME).o
	$(CC) -o $(NAME).nexe $(NAME).o $(LDFLAGS)
#genmanifest
	TIMEOUT=1000 \
	ABS_PATH=$(CURDIR) \
	NAME=$(NAME) \
	CHANNELS_INCLUDE=channels.manifest.include \
	../template.sh ../manifest.template > $(NAME).manifest
#gennvram
	VERBOSITY=2 \
	../template.sh ../nvram.template  > $(NAME).nvram
#	echo "[fstab]" >> $(NAME).nvram
#	echo "channel=/dev/tar, mountpoint=/, access=ro" >> $(NAME).nvram
#gen gdb script
	NEXE_PATH=$(CURDIR)/$(NAME).nexe \
	../template.sh ../debug.template > $(NAME).scp
#launch
	$(ZEROVM) -M$(NAME).manifest
	cat $(NAME).stdout.log

prepare:
	chmod u+rwx ../template.sh

clean:
	@rm -f *.nexe *.manifest *.nvram *.o *.log *.data *.scp *.null
