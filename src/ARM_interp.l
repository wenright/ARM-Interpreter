%{

extern char *cur_word;
extern long int offset;

#define YY_USER_ACTION	offset += yyleng;\
				cur_word = yytext;
				// printf("%s", yytext);

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"

void clear_buffer () {
	yy_flush_buffer(YY_CURRENT_BUFFER);
}

%}

%%

;.*$ {
	/* Ignore comments starting with semi-colons */
}

"//".*$ {
	/* Ignore comments starting with two slashes */
}

@.*$ {
	/* Ignore comments starting with at symbol */
}

[ \t]* {
	/* Discard spaces and tabs */
}

\".*\" {
	yylval.string = strndup(yytext + 1, strlen(yytext) - 1);
	return QUOTE;
}

\{ {
	return OPENBRACE;
}

\} {
	return CLOSEBRACE;
}

0|[1-9][0-9]* {
	yylval.number = atoi(yytext);
	return NUMBER;
}

r1[0-5] {
	/* A register beteween r10 and r15 */
	yylval.number = 10 + yytext[2] - '0';
	return REGISTER;
}

r[0-9] {
	/* A register beteween r0 and r9 */
	yylval.number = yytext[1] - '0';
	return REGISTER;
}

a[1-4] {
	/* Registers 0-3 have a different name as well,
		but these are 1 indexed instead of 0 */
	yylval.number = yytext[1] - '1';
	return REGISTER;
}

v[1-8] {
	/* This is an alternative name for r4-r11, these are
		1 indexed as well.  v1 == r4 */
	yylval.number = yytext[1] + '3';
	return REGISTER;
}

sb {
	/* static base or register variable */
	yylval.number = 9;
	return REGISTER;
}

sl {
	/* stack limit or register variable */
	yylval.number = 10;
	return REGISTER;
}

fp {
	/* frame pointer or register variable */
	yylval.number = 11;
	return REGISTER;
}

ip {
	/* scratch register */
	yylval.number = 12;
	return REGISTER;
}

sp {
	/* stack frame pointer */
	yylval.number = 13;
	return REGISTER;
}

lr {
	/* link register, holds the return address from a function call */
	yylval.number = 14;
	return REGISTER;
}

pc {
	/* program counter */
	yylval.number = 15;
	return REGISTER;
}

, {
	return COMMA;
}

# {
	return HASH;
}

".global" {
	return GLOBAL;
}

.asciz {
	return ASCIZ;
}

mov {
	return MOV;
}

cmp {
	return CMP;
}

ldr {
	return LDR;
}

add {
	return ADD;
}

sub {
	return SUB;
}

bl {
	return BL;
}

blt {
	return BLT;
}

bgt {
	return BGT;
}

printf {
	return PRINTF;
}

push {
	return PUSH;
}

pop {
	return POP;
}

swi {
	return SWI;
}

\n {
	return NEWLINE;
}

=[a-zA-Z0-9_]+ {
	yylval.string = strdup(yytext + 1);
	return FORMAT;
}

[a-zA-Z0-9_]+":" {
	yylval.string = strndup(yytext + 1, strlen(yytext) - 1);
	return LABEL;
}

\.?[a-zA-Z0-9_]+ {
	// Everything else
	yylval.string = strdup(yytext);
	return WORD;
}
