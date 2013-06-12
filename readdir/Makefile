include ../Makefile.env
TIMESTAMP=1349019070
NAME=readdir
NAME2=getdents

all: prepare $(NAME).nexe $(NAME2).nexe run 

prepare:
	chmod u+rwx ../template.sh

$(NAME).nexe: $(NAME).o
	$(CC) -o $(NAME).nexe $(NAME).o $(LDFLAGS)
	TIMEOUT=4 \
	ABS_PATH=$(CURDIR) \
	NAME=$(NAME) \
	CHANNELS_INCLUDE=channels.manifest.include \
	../template.sh ../manifest.template > $(NAME).manifest
	SECONDS=$(TIMESTAMP) ../template.sh ../nvram.template  > $(NAME).nvram
	NEXE_PATH=$(CURDIR)/$(NAME).nexe ../template.sh ../debug.template  > $(NAME).scp

$(NAME2).nexe: $(NAME2).o
	$(CC) -o $(NAME2).nexe $(NAME2).o $(LDFLAGS)
	TIMEOUT=4 \
	ABS_PATH=$(CURDIR) \
	NAME=$(NAME2) \
	CHANNELS_INCLUDE=channels.manifest.include \
	../template.sh ../manifest.template > $(NAME2).manifest
	SECONDS=$(TIMESTAMP) ../template.sh ../nvram.template  > $(NAME2).nvram
	NEXE_PATH=$(CURDIR)/$(NAME2).nexe ../template.sh ../debug.template  > $(NAME2).scp

run:
	$(ZEROVM) -M$(NAME).manifest
	cat $(NAME).stdout.log
	$(ZEROVM) -M$(NAME2).manifest
	cat $(NAME2).stdout.log

clean:
	@rm -f some.input
	@rm -f *.nexe *.manifest *.o *.log *.data *.null *.nvram *.scp
