include ../Makefile.env

NAME=reqrep
CFLAGS+=-std=c99

all: createdirs reqrep.nexe run

reqrep.nexe: reqrep.o
	@$(CC) -o $(NAME).nexe $(NAME).o $(LDFLAGS)

run:
	chmod u+rwx genmanifest.sh test.sh test-type2.sh
	./genmanifest.sh
	./test.sh	
	./test-type2.sh

createdirs:
	@mkdir -p log

clean: 
	@rm -f $(NAME).o
	@rm -f log/*.log
	@rm -f *.nexe
	@rm -f manifest/*.manifest
	@rm -f nameservice.log


