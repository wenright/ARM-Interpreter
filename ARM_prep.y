%token <string> LABEL WORD
%token NEWLINE GLOBAL COMMA ASCIZ QUOTE

%start statements

%union	{
	int number;
	char *string;
}

%{

#include "ARM_prep.h"

%}

%%

statements:
	statement
|
	statement statements
;

statement:
	label
|
	expression
|
	NEWLINE
;

label:
	LABEL {
		printf("Label found: %s\n", $1);
		if (entry_point.pos < 0 && !strcmp(entry_point.name, $1))
			entry_point.pos = offset;
		else if (findLabel($1) < 0)
			addLabel($1, offset);
	}
|
	GLOBAL WORD {
		entry_point.name = $2;
		entry_point.pos = -1;

		addLabel($2, offset);
	}
|
	ASCIZ QUOTE WORD QUOTE {
		// TODO
	}
;

// These don't have to do anything, just verify that they could in fact be statements
// Their interpreter counterparts are commented above
expression:
	// ex: MOV REG, ARG
	WORD WORD COMMA WORD
|
	// ex: ADD REG , ARG, ARG
	WORD WORD COMMA WORD COMMA WORD
|	
	// ex: BRANCH WORD
	WORD WORD
;

%%

void yyerror (char const *s) {
 	fprintf (stderr, "Pre-interpreter: %s\n", s);
}

