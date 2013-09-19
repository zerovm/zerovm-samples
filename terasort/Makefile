include ../Makefile.env
CFLAGS+=-std=c99 -g
LDFLAGS+=-lmapreduce -lnetworking
GENSORT=gensort-1.5
GENSORT_HTTP=http://www.ordinal.com/try.cgi/gensort-1.5.tar.gz
GENSORT_TAR=gensort-1.5.tar.gz

all: prepare clean map.nexe reduce.nexe gensort
	@./gendatamanifest.sh

map.nexe: obj/map.o obj/user_implem.o
	@$(CC) -o map.nexe obj/map.o obj/user_implem.o $(LDFLAGS)

reduce.nexe: obj/reduce.o obj/user_implem.o
	@$(CC) -o reduce.nexe obj/reduce.o obj/user_implem.o $(LDFLAGS)

obj/map.o: src/map.c
	@$(CC) -c -o obj/map.o ${CFLAGS} src/map.c

obj/reduce.o: src/reduce.c
	@$(CC) -c -o obj/reduce.o ${CFLAGS} src/reduce.c

obj/user_implem.o: src/user_implem.c src/user_implem.h
	@$(CC) -c -o obj/user_implem.o ${CFLAGS} src/user_implem.c -D_GNU_SOURCE

prepare:
	@if test ! -d $(GENSORT) ; then \
		if test ! -f $(GENSORT_TAR) ; then \
			wget $(GENSORT_HTTP) ; \
		fi ; \
		tar xvzf $(GENSORT_TAR) ;\
	fi
	@cp Makefile.valsort.zerovm $(GENSORT)/Makefile.valsort.zerovm
	@chmod u+rwx gendatamanifest.sh start.sh
	@mkdir -p obj log data

valsort:
gensort:
	@make -C$(GENSORT) -fMakefile.valsort.zerovm clean all
	@cp $(GENSORT)/valsort.nexe . -f
	@make -C$(GENSORT) -fMakefile.valsort.zerovm clean
	@make -C$(GENSORT)
	@cp $(GENSORT)/gensort . -f

clean: 
	@rm -f obj/*.o
	@rm -f log/*.log
	@rm -f *.txt
	@rm -f data/*.txt
	@rm -f data/*.dat
	@rm -f data/*.sum
	@rm -f manifest/*.manifest	
	@rm -f nvram/*.nvram
	@rm -f *.nexe
	@rm -f nameservice.log gensort valsort


