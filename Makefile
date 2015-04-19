cc = gcc -g
CC = g++ -g

LEX=lex
YACC=yacc

all: interpreter

lex.zz.o: src/ARM_prep.l 
	$(LEX) src/ARM_prep.l
	$(CC) -c src/lex.zz.c

z.tab.o: src/ARM_prep.y
	$(YACC) -t -v -d -p zz -b z src/ARM_prep.y
	$(CC) -c src/z.tab.c


lex.yy.o: src/ARM_interp.l 
	$(LEX) src/ARM_interp.l
	$(CC) -c src/lex.yy.c

y.tab.o: src/ARM_interp.y
	$(YACC) -t -v -d src/ARM_interp.y
	$(CC) -c src/y.tab.c

interpreter: clean src/main.cpp src/z.tab.o src/lex.zz.o src/y.tab.o src/lex.yy.o
	$(CC) src/main.cpp -o src/interpreter src/lex.yy.o src/y.tab.o src/lex.zz.o src/z.tab.o -lfl

clean:
	rm -f src/lex.??.c src/?.tab.c src/?.tab.h src/?.output src/interp *.o

