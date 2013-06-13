include ../Makefile.env
NAME=hello

CFLAGS+=-g2

all: prepare $(NAME).o
	$(CC) -o $(NAME).nexe $(NAME).o $(LDFLAGS)
	TIMEOUT=5 \
	ABS_PATH=$(CURDIR) \
	NAME=$(NAME) \
	CHANNELS_INCLUDE=channels.manifest.include \
	../template.sh ../manifest.template > $(NAME).manifest
	../template.sh ../nvram.template  > $(NAME).nvram
	$(ZEROVM) -M$(NAME).manifest
	cat $(NAME).stdout.log

prepare:
	chmod u+rwx ../template.sh

clean:
	@rm -f *.nexe *.manifest *.nvram *.o *.log *.data *.scp *.null
