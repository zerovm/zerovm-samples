include ../Makefile.env
CFLAGS+=-O2
NAME=time
TIMESTAMP=$(shell date +%s)

all: $(NAME).o
	$(CC) -o $(NAME).nexe $(NAME).o $(LDFLAGS)
#genmanifest
	TIMEOUT=5 \
	ABS_PATH=$(CURDIR) \
	NAME=$(NAME) \
	CHANNELS_INCLUDE=channels.manifest.include \
	../template.sh ../manifest.template > $(NAME).manifest
#gennvram
	SECONDS=$(TIMESTAMP) \
	../template.sh  ../nvram.template > $(NAME).nvram
	$(ZEROVM) -M$(NAME).manifest
	@cat time.stdout.log

clean:
	@rm -f $(NAME).nexe $(NAME).o *.log *.std *.manifest *.nvram
