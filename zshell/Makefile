include ../Makefile.env

NAME=zshell

CFLAGS+=-std=c99 -g -DDEBUG

#Add python include path
CFLAGS+=-Izpython -Izpython/Include
LDFLAGS+=-llua -lsqlite3 
LDFLAGS+=-Lzpython -lpython3.2m -lm -ldl -lutil

all: createdirs $(NAME).nexe run

.PHONY: zpython

zpython:
	cd zpython; sh 1build_pgen.sh
	cd zpython; sh 2configure_zpython.sh
	cd zpython; sh 3build_zpython_statically.sh

$(NAME).nexe: src/pythonexec.o src/luaexec.o src/main.o src/sqlitequery.o
	$(CC) -o $(NAME).nexe src/pythonexec.o src/luaexec.o src/main.o src/sqlitequery.o $(LDFLAGS)  

createdirs:
	mkdir -p nvram
	chmod u+rwx ../template.sh
	chmod u+rwx genmanifest.sh run_lua_samples.sh run_sqlite_samples.sh run_python_samples.sh run_python_samples.sh
	chmod u+rwx python/python.sh lua/lua.sh sqlite/sqlite.sh sqlite/sqlite-cdr.sh 
	@mkdir -p log
	@if test ! -f zpython/Makefile ; then \
		echo "Error: Please git clone zpython from https://github.com/zerovm/zpython"; \
		echo "       And install it by running: make zpython"; \
		exit 1; \
	fi

clean: 
	@rm -f src/*.o
	@find -name "*.stdout" | xargs rm -f
	@find -name "*.log" | xargs rm -f
	@find -name "*.manifest" | xargs rm -f
	@find -name "*.nvram" | xargs rm -f
	@rm -f $(NAME).nexe

run:
#gen gdb script for debug purposes
	NEXE_PATH=$(CURDIR)/$(NAME).nexe \
	../template.sh ../debug.template > $(NAME).scp
#run
	./run_lua_samples.sh  
	./run_python_samples.sh  
	./run_sqlite_samples.sh
