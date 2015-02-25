include ../Makefile.env
NAME=unionfs

#special toolchain's gcc flag
LDFLAGS+=-archivemount -unionfs
CFLAGS+=-g2

all: prepare $(NAME).o
	$(CC) -o $(NAME).nexe $(NAME).o $(LDFLAGS)
#genmanifest
# 256 MB	
	MEMORY=268435456 \
	TIMEOUT=1000 \
	ABS_PATH=$(CURDIR) \
	NAME=$(NAME) \
	CHANNELS_INCLUDE=channels.manifest.include \
	../template.sh ../manifest.template > $(NAME).manifest
#gennvram
	VERBOSITY=2 \
	../template.sh ../nvram.template  > $(NAME).nvram
	echo "[fstab]" >> $(NAME).nvram
	echo "channel=/dev/tar, mountpoint=/mnt/tar, access=ro, fsname=archivemount" >> $(NAME).nvram
	echo "channel=/tmp=RW:/mnt/tar=RO /tar, mountpoint=/tar, access=ro, fsname=unionfs" >> $(NAME).nvram
#gen gdb script
	NEXE_PATH=$(CURDIR)/$(NAME).nexe \
	../template.sh ../debug.template > $(NAME).scp
#launch
	$(ZEROVM) -M$(NAME).manifest
	cat $(NAME).stdout.log

prepare: unionfs.tar
	chmod u+rwx ../template.sh

unionfs.tar:
	tar -cvf $@ Makefile

clean:
	@rm -f *.tar *.nexe *.manifest *.nvram *.o *.log *.data *.scp *.null
