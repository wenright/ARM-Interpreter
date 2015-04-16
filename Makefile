cc = gcc -g
CC = g++ -g

LEX=lex
YACC=yacc

all: interp

lex.yy.o: ARM_interp.l 
	$(LEX) ARM_interp.l
	$(CC) -c lex.yy.c

y.tab.o: ARM_interp.y
	$(YACC) -t -v -d ARM_interp.y
	$(CC) -c y.tab.c

interp: y.tab.o lex.yy.o
	$(CC) -o interp lex.yy.o y.tab.o -lfl

clean:
	rm -f lex.yy.c y.tab.c y.tab.h interp *.o

