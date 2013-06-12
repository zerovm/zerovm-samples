include ../Makefile.env

NAME=tarimage

all: $(NAME).o
	$(CC) -o $(NAME).nexe  $(NAME).o $(LDFLAGS)
	NAME=$(NAME) \
	ABS_PATH=$(CURDIR) \
	TIMEOUT=5 \
	CHANNELS_INCLUDE=channels.manifest.include \
	../template.sh ../manifest.template > $(NAME).manifest
	@sed s@{NEXE_PATH}@${CURDIR}/$(NAME).nexe@g ../debug.template  > $(NAME).scp
	$(ZEROVM) -M$(NAME).manifest
	cat stdout.data
	cat stderr.data

clean:
	@rm -f $(NAME).nexe $(NAME).o $(NAME).manifest *.log *.data *.scp
