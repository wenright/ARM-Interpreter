%{

long int i_offset = 0;
char *cur_word;
#define YY_USER_ACTION	i_offset += yyleng;\
				cur_word = yytext;

#include <string.h>
#include "y.tab.h"

%}

%%

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

[1-9][0-9]* {
	yylval.number = atoi(yytext);
	return NUMBER;
}

: {
	return COLON;
}

, {
	return COMMA;
}

# {
	return HASH;
}

;.*$ {
	/* Ignore comments starting with semi-colons */
}

"//".*$ {
	/* Ignore comments starting with two slashes */
}

[ \t]* {
	/* Discard spaces and tabs */
}

".global" {
	return GLOBAL;
}

.asciz {
	return ASCIZ;
}

\" {
	return QUOTE;
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

print {
	return PRINT;
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
