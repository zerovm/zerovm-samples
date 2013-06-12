include ${ZRT_ROOT}/Makefile.env
NAME=cgioutput

all: prepare $(NAME).o
	$(CC) -o $(NAME).nexe $(NAME).o $(LDFLAGS)
	TIMEOUT=4 \
	CHANNELS_INCLUDE=channels.manifest.include \
	ABS_PATH=$(CURDIR) \
	NAME=$(NAME) ../template.sh ../manifest.template > $(NAME).manifest
	SECONDS= ../template.sh ../nvram.template  > $(NAME).nvram
	$(ZEROVM) -M$(NAME).manifest

prepare:
	chmod u+rwx ../template.sh

clean:
	@rm -f *.nexe *.manifest *.nvram *.o *.log *.data *.null
