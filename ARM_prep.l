%option prefix="zz"
%option outfile="lex.zz.c"
%option noyywrap

%{

long int offset = 0;

#define YY_USER_ACTION offset += yyleng;

#include <string.h>
#include "z.tab.h"

%}

%%

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

".asciz" {
	return ASCIZ;
}

\" {
	return QUOTE;
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

\.?[a-zA-Z0-9_\[\]=#]+ {
	// Everything else
	zzlval.string = strdup(yytext);
	return WORD;
}
