cc = gcc -g -std=gnu99

LEX=lex
YACC=yacc -d

all: interpreter

lex.zz.o: ARM_prep.l 
	$(LEX) ARM_prep.l
	$(cc) -c lex.zz.c

z.tab.o: ARM_prep.y
	$(YACC) -p zz -b z ARM_prep.y
	$(cc) -c z.tab.c


lex.yy.o: ARM_interp.l 
	$(LEX) ARM_interp.l
	$(cc) -c lex.yy.c

y.tab.o: ARM_interp.y
	$(YACC) ARM_interp.y
	$(cc) -c y.tab.c

interpreter: main.c stack.c z.tab.o lex.zz.o y.tab.o lex.yy.o
	$(cc) main.c -o ../interpreter stack.c lex.yy.o y.tab.o lex.zz.o z.tab.o -lfl

clean:
	rm -f lex.??.c ?.tab.c ?.tab.h ?.output ../interpreter *.o