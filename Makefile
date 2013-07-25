## Whistlepig Makefile
## Copyright (c) 2011 William Morgan <wmorgan@masanjin.net>
## Whistlepig is released under the three-clause BSD license. See the COPYING
## file for terms.

LEX=flex
YACC=bison
CC=gcc
RUBY=/usr/bin/ruby
ECHO=/bin/echo

## stolen from redis
uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')
OPTIMIZATION?=-O3

CFLAGS?= -std=c99 $(OPTIMIZATION) -Wall -Wextra -Wwrite-strings -Werror -Wpointer-arith -Wwrite-strings -Wno-missing-field-initializers -Wno-long-long -D_XOPEN_SOURCE=600

ifeq ($(uname_S),Darwin)
CFLAGS:=$(CFLAGS) -Wshorten-64-to-32
endif

CCLINK?= -pthread
CCOPT= $(CFLAGS) $(CCLINK) $(ARCH) $(PROF)
DEBUG?= -rdynamic -ggdb

TESTFILES = test-segment.c test-stringmap.c test-stringpool.c test-termhash.c test-search.c test-labels.c test-tokenizer.c test-queries.c test-snippets.c
CSRCFILES = segment.c termhash.c stringmap.c error.c query.c search.c stringpool.c mmap-obj.c query-parser.c index.c entry.c lock.c snippeter.c
HEADERFILES = $(CSRCFILES:.c=.h) defaults.h whistlepig.h khash.h rarray.h
LEXFILES = tokenizer.lex query-parser.lex
YFILES = query-parser.y
GENFILES = $(LEXFILES:.lex=.lex.c) $(LEXFILES:.lex=.lex.h) $(YFILES:.y=.tab.c) $(YFILES:.y=.tab.h)
OBJ = $(CSRCFILES:.c=.o) $(LEXFILES:.lex=.lex.o) $(YFILES:.y=.tab.o)

QUERYBIN=query
DUMPBIN=dump
ADDBIN=add
MBOXADDBIN=addmbox
TESTBIN = $(TESTFILES:.c=)
ALLBIN=$(QUERYBIN) $(DUMPBIN) $(ADDBIN) $(MBOXADDBIN) batch-run-queries benchmark-queries

all: $(ALLBIN)

## remove implicit rules because they fuck with my shit
.SUFFIXES:

loc: $(CSRCFILES) $(LEXFILES) $(YFILES) $(HEADERFILES)
	sloccount $+

## deps (use `make dep` to generate this (in vi: :r !make dep)
batch-run-queries.o: batch-run-queries.c whistlepig.h defaults.h index.h \
 segment.h stringmap.h stringpool.h error.h termhash.h query.h search.h \
 mmap-obj.h entry.h khash.h rarray.h query-parser.h lock.h snippeter.h \
 timer.h
benchmark-queries.o: benchmark-queries.c whistlepig.h defaults.h index.h \
 segment.h stringmap.h stringpool.h error.h termhash.h query.h search.h \
 mmap-obj.h entry.h khash.h rarray.h query-parser.h lock.h snippeter.h \
 timer.h
dump.o: dump.c whistlepig.h defaults.h index.h segment.h stringmap.h \
 stringpool.h error.h termhash.h query.h search.h mmap-obj.h entry.h \
 khash.h rarray.h query-parser.h lock.h snippeter.h
entry.o: entry.c whistlepig.h defaults.h index.h segment.h stringmap.h \
 stringpool.h error.h termhash.h query.h search.h mmap-obj.h entry.h \
 khash.h rarray.h query-parser.h lock.h snippeter.h tokenizer.lex.h
error.o: error.c error.h
file-indexer.o: file-indexer.c timer.h whistlepig.h defaults.h index.h \
 segment.h stringmap.h stringpool.h error.h termhash.h query.h search.h \
 mmap-obj.h entry.h khash.h rarray.h query-parser.h lock.h snippeter.h
index.o: index.c whistlepig.h defaults.h index.h segment.h stringmap.h \
 stringpool.h error.h termhash.h query.h search.h mmap-obj.h entry.h \
 khash.h rarray.h query-parser.h lock.h snippeter.h
interactive.o: interactive.c whistlepig.h defaults.h index.h segment.h \
 stringmap.h stringpool.h error.h termhash.h query.h search.h mmap-obj.h \
 entry.h khash.h rarray.h query-parser.h lock.h snippeter.h timer.h
lock.o: lock.c whistlepig.h defaults.h index.h segment.h stringmap.h \
 stringpool.h error.h termhash.h query.h search.h mmap-obj.h entry.h \
 khash.h rarray.h query-parser.h lock.h snippeter.h
make-queries.o: make-queries.c tokenizer.lex.h segment.h defaults.h \
 stringmap.h stringpool.h error.h termhash.h query.h search.h mmap-obj.h
mbox-indexer.o: mbox-indexer.c whistlepig.h defaults.h index.h segment.h \
 stringmap.h stringpool.h error.h termhash.h query.h search.h mmap-obj.h \
 entry.h khash.h rarray.h query-parser.h lock.h snippeter.h timer.h
mmap-obj.o: mmap-obj.c whistlepig.h defaults.h index.h segment.h \
 stringmap.h stringpool.h error.h termhash.h query.h search.h mmap-obj.h \
 entry.h khash.h rarray.h query-parser.h lock.h snippeter.h
query-parser.o: query-parser.c whistlepig.h defaults.h index.h segment.h \
 stringmap.h stringpool.h error.h termhash.h query.h search.h mmap-obj.h \
 entry.h khash.h rarray.h query-parser.h lock.h snippeter.h \
 query-parser.tab.h
query-parser.lex.o: query-parser.lex.c whistlepig.h defaults.h index.h \
 segment.h stringmap.h stringpool.h error.h termhash.h query.h search.h \
 mmap-obj.h entry.h khash.h rarray.h query-parser.h lock.h snippeter.h \
 query-parser.tab.h
query-parser.tab.o: query-parser.tab.c query.h segment.h defaults.h \
 stringmap.h stringpool.h error.h termhash.h search.h mmap-obj.h \
 query-parser.h query-parser.tab.h
query.o: query.c whistlepig.h defaults.h index.h segment.h stringmap.h \
 stringpool.h error.h termhash.h query.h search.h mmap-obj.h entry.h \
 khash.h rarray.h query-parser.h lock.h snippeter.h
search.o: search.c whistlepig.h defaults.h index.h segment.h stringmap.h \
 stringpool.h error.h termhash.h query.h search.h mmap-obj.h entry.h \
 khash.h rarray.h query-parser.h lock.h snippeter.h
segment.o: segment.c whistlepig.h defaults.h index.h segment.h \
 stringmap.h stringpool.h error.h termhash.h query.h search.h mmap-obj.h \
 entry.h khash.h rarray.h query-parser.h lock.h snippeter.h
snippeter.o: snippeter.c whistlepig.h defaults.h index.h segment.h \
 stringmap.h stringpool.h error.h termhash.h query.h search.h mmap-obj.h \
 entry.h khash.h rarray.h query-parser.h lock.h snippeter.h \
 tokenizer.lex.h
stringmap.o: stringmap.c whistlepig.h defaults.h index.h segment.h \
 stringmap.h stringpool.h error.h termhash.h query.h search.h mmap-obj.h \
 entry.h khash.h rarray.h query-parser.h lock.h snippeter.h
stringpool.o: stringpool.c whistlepig.h defaults.h index.h segment.h \
 stringmap.h stringpool.h error.h termhash.h query.h search.h mmap-obj.h \
 entry.h khash.h rarray.h query-parser.h lock.h snippeter.h
termhash.o: termhash.c whistlepig.h defaults.h index.h segment.h \
 stringmap.h stringpool.h error.h termhash.h query.h search.h mmap-obj.h \
 entry.h khash.h rarray.h query-parser.h lock.h snippeter.h
test-labels.o: test-labels.c test.h query.h segment.h defaults.h \
 stringmap.h stringpool.h error.h termhash.h search.h mmap-obj.h \
 query-parser.h index.h entry.h khash.h rarray.h
test-labels_main.o: test-labels_main.c error.h test.h
test-queries.o: test-queries.c test.h query.h segment.h defaults.h \
 stringmap.h stringpool.h error.h termhash.h search.h mmap-obj.h \
 query-parser.h
test-queries_main.o: test-queries_main.c error.h test.h
test-search.o: test-search.c test.h query.h segment.h defaults.h \
 stringmap.h stringpool.h error.h termhash.h search.h mmap-obj.h \
 query-parser.h index.h entry.h khash.h rarray.h
test-search_main.o: test-search_main.c error.h test.h
test-segment.o: test-segment.c test.h segment.h defaults.h stringmap.h \
 stringpool.h error.h termhash.h query.h search.h mmap-obj.h \
 tokenizer.lex.h index.h entry.h khash.h rarray.h
test-segment_main.o: test-segment_main.c error.h test.h
test-snippets.o: test-snippets.c test.h whistlepig.h defaults.h index.h \
 segment.h stringmap.h stringpool.h error.h termhash.h query.h search.h \
 mmap-obj.h entry.h khash.h rarray.h query-parser.h lock.h snippeter.h
test-stringmap.o: test-stringmap.c stringmap.h stringpool.h error.h \
 test.h
test-stringpool.o: test-stringpool.c stringpool.h error.h test.h
test-stringpool_main.o: test-stringpool_main.c error.h test.h
test-termhash.o: test-termhash.c termhash.h error.h test.h
test-termhash_main.o: test-termhash_main.c error.h test.h
test-tokenizer.o: test-tokenizer.c test.h tokenizer.lex.h segment.h \
 defaults.h stringmap.h stringpool.h error.h termhash.h query.h search.h \
 mmap-obj.h
test-tokenizer_main.o: test-tokenizer_main.c error.h test.h
tokenizer.lex.o: tokenizer.lex.c segment.h defaults.h stringmap.h \
 stringpool.h error.h termhash.h query.h search.h mmap-obj.h

benchmark-queries: benchmark-queries.o $(OBJ)
	@$(ECHO) LINK $@
	@$(CC) -o $@ $(CCOPT) $(DEBUG) $+

batch-run-queries: batch-run-queries.o $(OBJ)
	@$(ECHO) LINK $@
	@$(CC) -o $@ $(CCOPT) $(DEBUG) $+

$(QUERYBIN): $(OBJ) interactive.o
	@$(ECHO) LINK $@
	@$(CC) -o $@ $(CCOPT) $(DEBUG) $+

$(ADDBIN): $(OBJ) file-indexer.o
	@$(ECHO) LINK $@
	@$(CC) -o $@ $(CCOPT) $(DEBUG) $+

$(MBOXADDBIN): $(OBJ) mbox-indexer.o
	@$(ECHO) LINK $@
	@$(CC) -o $@ $(CCOPT) $(DEBUG) $+

$(DUMPBIN): $(OBJ) dump.o
	@$(ECHO) LINK $@
	@$(CC) -o $@ $(CCOPT) $(DEBUG) $+

test-%_main.c: test-%.c
	@$(ECHO) MAGIC $<
	@$(RUBY) build/gen-test-main.rb $+ > $@

test-%: test-%.o test-%_main.o $(OBJ)
	@$(ECHO) LINK $@
	@$(CC) -o $@ $(CCOPT) $(DEBUG) $+

## these next two rules are to ignore warnings in generated c code
tokenizer.lex.o: tokenizer.lex.c
	@$(ECHO) CC \(ignore warnings\) $<
	@$(CC) -c $(CFLAGS) $(DEBUG) $(DEBUGOUTPUT) $(COMPILE_TIME) -w $<

query-parser.lex.o: query-parser.lex.c
	@$(ECHO) CC \(ignore warnings\) $<
	@$(CC) -c $(CFLAGS) $(DEBUG) $(DEBUGOUTPUT) $(COMPILE_TIME) -w $<

## object compilation
%.o: %.c
	@$(ECHO) CC $<
	@$(CC) -c $(CFLAGS) $(DEBUG) $(DEBUGOUTPUT) $(COMPILE_TIME) $<

%.lex.c %.lex.h: %.lex
	@$(ECHO) LEX $+
	$(LEX) $<

%.tab.c %.tab.h: %.y
	@$(ECHO) YACC $+
	$(YACC) $<

clean:
	rm -rf $(TESTBIN) *.o *.gcda *.gcno *.gcov $(GENFILES) $(ALLBIN)

dep: $(GENFILES)
	$(CC) -MM *.c

test: $(TESTBIN)
	./test-segment
	./test-stringmap
	./test-stringpool
	./test-termhash
	./test-search
	./test-labels
	./test-queries
	./test-snippets

integration-tests/enron1m.index0.pr: integration-tests/enron1m.mbox $(MBOXADDBIN) $(OBJ)
	rm -f integration-tests/enron1m.index*
	./$(MBOXADDBIN) integration-tests/enron1m.index integration-tests/enron1m.mbox

test-integration: batch-run-queries integration-tests/enron1m.index0.pr
	ruby integration-tests/eval.rb integration-tests/testset1.txt

debug:
	make DEBUGOUTPUT=-DDEBUGOUTPUT

EXPORTFILES=$(CSRCFILES) $(HEADERFILES) $(GENFILES)
rubygem: $(EXPORTFILES)
	cp README COPYING ruby
	cp $+ ruby/ext/whistlepig
	cd ruby && rake gem
	@echo gem is in ruby/pkg/
