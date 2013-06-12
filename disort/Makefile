include ../Makefile.env

#DEBUG=-g
CFLAGS +=-I. -Isrc -std=c99 -O2 $(DEBUG)
LDFLAGS+=-lnetworking

GENNODE=generator.uint32_t
MANNODE=nodeman
SRCNODE=nodesrc
DSTNODE=nodedst

NEXES = $(GENNODE).nexe $(MANNODE).nexe $(SRCNODE).nexe $(DSTNODE).nexe
GENNODE_OBJECTS = src/generator.uint32_t.o
MANNODE_OBJECTS = src/comm.o src/bitonic_sort.o src/manager/main_man.o src/manager/histanlz.o src/manager/comm_man.o src/dsort.o src/sort.o
SRCNODE_OBJECTS = src/comm.o src/source/comm_src.o src/source/main_src.o src/cpuid.o src/bitonic_sort.o src/dsort.o src/sort.o
DSTNODE_OBJECTS = src/dest/main_dst.o src/dest/comm_dst.o src/comm.o src/dsort.o src/sort.o

all: cleanlog prepare $(NEXES) 

$(GENNODE).nexe: $(GENNODE_OBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS)

$(MANNODE).nexe: $(MANNODE_OBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS)

$(SRCNODE).nexe: $(SRCNODE_OBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS)

$(DSTNODE).nexe: $(DSTNODE_OBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS)

cleanlog:
	@rm -f log/*.log

prepare: createdirs
	@chmod u=rwx disort.sh
	@chmod u=rwx gendata.sh
	@chmod u=rwx genmanifest.sh
	@./genmanifest.sh

createdirs:
	@mkdir -p log data

clean: cleanlog 
	@rm -f $(NEXES)
	@rm -f $(GENNODE_OBJECTS) $(MANNODE_OBJECTS) $(SRCNODE_OBJECTS) $(DSTNODE_OBJECTS)
	@rm -f manifest/*.manifest
	@rm -f nvram/*.nvram
	@rm -f data/*.data
	@rm -f nameservice.log


