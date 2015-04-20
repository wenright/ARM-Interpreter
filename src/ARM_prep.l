%option prefix="zz"
%option outfile="lex.zz.c"
%option noyywrap

%{

extern char *cur_word;
extern long int offset;
#define YY_USER_ACTION 	offset += yyleng;\
				cur_word = yytext;

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "z.tab.h"

%}

%%

\".*\" {
	zzlval.string = strndup(yytext + 1, strlen(yytext) - 2);
	return QUOTE;
}

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

".global" {
	return GLOBAL;
}

".asciz"|".ascii" {
	return ASCIZ;
}

\n {
	return NEWLINE;
}

, {
	return COMMA;
}

[a-zA-Z0-9_]+: {
	zzlval.string = strndup(yytext, strlen(yytext) - 1);
	return LABEL;
}

\.?[a-zA-Z0-9_\[\]=#\{\}]+ {
	// Everything else
	zzlval.string = strdup(yytext);
	return WORD;
}
