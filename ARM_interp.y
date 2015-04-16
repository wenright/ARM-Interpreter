%token <string> WORD
%token <number> NUMBER REGISTER
%token COMMA COLON HASH NEWLINE 
%token MAIN MOV CMP LDR ADD SUB BRANCH BLT BGT PRINT

%type <number> argument

%union	{
	int number;
	char *string;
}

%{

#include "ARM_interp.h"

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
	WORD COLON {
		if (findLabel($1) < 0) {
			if (num_labels >= max_labels) {
				// Create additional labels
				max_labels *= 2;
				labels = (struct label *) realloc(labels, sizeof(struct label) * max_labels);
			}

			// Store the name of this label for lookup later
			labels[num_labels].name = strdup($1);

			// Remember the position in the file to come back to it
			// fgetpos(yyin, &labels[num_labels].pos);
			labels[num_labels].pos = ftell(yyin) + strlen($1) + 1;

			num_labels++;
		}
	}
|
	MAIN
;

expression:
	MOV REGISTER COMMA argument {
		r[$2].int_val = $4;
	}
|
	LDR REGISTER COMMA argument {

	}
|
	ADD REGISTER COMMA argument COMMA argument {
		r[$2].int_val = $4 + $6;
		printf("RESULT: %d\n", r[$2].int_val);
	}
|
	SUB REGISTER COMMA argument COMMA argument {
		r[$2].int_val = $4 - $6;
		printf("RESULT: %d\n", r[$2].int_val);
	}
|
	BRANCH WORD {
		// Branch to $2
		int label_index = findLabel($2);

		// label_index will be -1 if search fails
		assert(label_index >= 0);

		// Reset yyin to be at he position of the label
		// fsetpos(yyin, &labels[label_index].pos);
		fseek(yyin, labels[num_labels].pos, SEEK_SET);
	}
|
	CMP REGISTER COMMA argument {
		// TODO set flags based on eq, lt, gt, etc...
		// Alternatively, do nothing and compute later in BGT etc
	}
|
	BGT WORD {
		// TODO Branch greater than
	}
|
	BLT WORD {
		// TODO Branch less than
	}
|
	PRINT REGISTER {
		printf(r[0].str_val, r[1].int_val);
	}
;

argument:
	REGISTER {
		$$ = r[$1].int_val;
	}
|
	HASH NUMBER {
		$$ = $2;
	}
;

%%

void yyerror(const char * s) {
	fprintf(stderr,"%s\n", s);
}

int main(int argc, char **argv) {
	// yydebug = 1;

	// Load selected file as input
	if (argc > 1 && (yyin = fopen(argv[argc - 1], "r")) == NULL) {
		perror("fopen");
		return 1;
	}

	// Create initial empty list of labels
	labels = (struct label *) malloc(sizeof(struct label) * max_labels);

	yyparse();

	// TODO Free things here?
	for (int i = 0; i < num_labels; ++i) {
		printf("label %d: name=%s\n", i, labels[i].name);
		free(labels[i].name);
	}

	return 0;
}

int findLabel(char *name) {
	for (int i = 0; i < num_labels; ++i)
		if (!strcmp(labels[i].name, name))
			return i;
	
	return -1;
}
