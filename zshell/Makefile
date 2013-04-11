include ../Makefile.env

CFLAGS+=-std=c99 -g -DDEBUG

#Add python include path
CFLAGS+=-Izpython -Izpython/Include

LDFLAGS+=-llua -lsqlite3 

LDFLAGS+=-Lzpython -lpython3.2m -lm -ldl -lutil

all: createdirs zshell.nexe

.PHONY: zpython

zpython:
	cd zpython; sh 1build_pgen.sh
	cd zpython; sh 2configure_zpython.sh
	cd zpython; sh 3build_zpython_statically.sh

zshell.nexe: pythonexec.o luaexec.o main.o sqlitequery.o
	$(CC) -o zshell.nexe pythonexec.o luaexec.o main.o sqlitequery.o $(LDFLAGS)  

createdirs:
	chmod u+rwx genmanifest.sh run_lua_samples.sh run_sqlite_samples.sh run_python_samples.sh python.sh \
run_python_samples.sh
	@mkdir -p log
	@if test ! -d zpython ; then \
		echo "Error: Please get zpython from https://github.com/zerovm/zpython"; \
		exit 1; \
	fi

clean: 
	@rm -f *.o
	@find -name "*.stdout" | xargs rm -f
	@find -name "*.log" | xargs rm -f
	@find -name "*.manifest" | xargs rm -f
	@rm -f zshell.nexe


