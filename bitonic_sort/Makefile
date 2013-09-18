include ../Makefile.env
CFLAGS+=-O2 -msse4.1 -Isrc

NAME_1=generator.uint32_t
NAME_2=sort_uint_proper_with_args
NAME_3=tester.uint32_t

all: src/$(NAME_1).o src/$(NAME_2).o src/$(NAME_3).o src/cpuid.o
	$(CC) -o $(NAME_1).nexe src/$(NAME_1).o src/cpuid.o $(LDFLAGS)
	$(CC) -o $(NAME_2).nexe src/$(NAME_2).o src/cpuid.o $(LDFLAGS)
	$(CC) -o $(NAME_3).nexe src/$(NAME_3).o src/cpuid.o $(LDFLAGS)
	chmod u+rwx run_test.sh genmanifest.sh
	./run_test.sh

$(NAME_1).o:
$(NAME_2).o:
$(NAME_3).o:
cpuid.o:
	$(eval BASENAME:=$(basename $@))
	$(CC) -o $(BASENAME).o $(CFLAGS) $(BASENAME).c

clean:
	@rm -f *.nexe src/*.o *.log *.data manifest/*.manifest
