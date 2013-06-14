include $(ZRT_ROOT)/Makefile.env
NAME=gtest_test

CXXFLAGS+=-g2 -I$(ZRT_ROOT)/libports/gtest
LDFLAGS+=-lgtest

all: $(NAME).o
	$(CXX) -o $(NAME).nexe $(NAME).o $(LDFLAGS)
#genmanifest
	TIMEOUT=100 \
	ABS_PATH=$(CURDIR) \
	NAME=$(NAME) \
	CHANNELS_INCLUDE=channels.manifest.include \
	../template.sh ../manifest.template > $(NAME).manifest
#launch
	$(ZEROVM) -M$(NAME).manifest
	cat $(NAME).stdout.log

clean:
	rm -f *.nexe *.o *.log *.result *.manifest

