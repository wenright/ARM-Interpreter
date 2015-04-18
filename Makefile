cc = gcc -g
CC = g++ -g

LEX=lex
YACC=yacc

all: interp

lex.zz.o: ARM_prep.l 
	$(LEX) ARM_prep.l
	$(CC) -c lex.zz.c

z.tab.o: ARM_prep.y
	$(YACC) -t -v -d -p zz -b z ARM_prep.y
	$(CC) -c z.tab.c


lex.yy.o: ARM_interp.l 
	$(LEX) ARM_interp.l
	$(CC) -c lex.yy.c

y.tab.o: ARM_interp.y
	$(YACC) -t -v -d ARM_interp.y
	$(CC) -c y.tab.c

interp: clean main.cpp z.tab.o lex.zz.o y.tab.o lex.yy.o
	$(CC) main.cpp -o interp lex.yy.o y.tab.o lex.zz.o z.tab.o -lfl

clean:
	rm -f lex.??.c ?.tab.c ?.tab.h ?.output interp *.o

