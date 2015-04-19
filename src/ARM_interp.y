%token <string> WORD FORMAT LABEL QUOTE
%token <number> NUMBER REGISTER
%token COMMA HASH NEWLINE 
%token GLOBAL MOV CMP LDR ADD SUB BL BLT BGT PRINT
	 ASCIZ PUSH POP CLOSEBRACE OPENBRACE

%type <number> argument

%start statements

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

// We can ignore these, they have already been cached
label:
	LABEL
|
	GLOBAL WORD
|
	ASCIZ QUOTE
;

expression:
	MOV REGISTER COMMA argument {
		r[$2].int_val = $4;
		r[$2].type = 'i';
	}
|
	LDR REGISTER COMMA FORMAT {
		// TODO memory leak?
		r[$2].str_val = strdup($4);
		r[$2].type = 's';
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
	BL WORD {
		// Branch to $2
		int label_index = findLabel($2);

		// label_index will be -1 if search fails, implying this label doesn't exist
		assert(("Label not found", label_index >= 0));

		printf("Branching to label[%d], \"%s\", %lu chars in.\n", 
			label_index, labels[label_index].name, labels[label_index].pos);

		// Reset yyin to be at he position of the label
		fseek(yyin, labels[label_index].pos, SEEK_SET);
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
		// printf(r[0].str_val);
		puts(r[0].str_val);
	}
|
	PUSH OPENBRACE REGISTER CLOSEBRACE {
		// TODO
	}
|
	POP OPENBRACE REGISTER CLOSEBRACE {
		// TODO
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
	fprintf(stderr,"Interpreter: %s\n\tPossible unknown identifier: \"%s\"\n\t%lu chars deep\n", 
		s, cur_word, i_offset);
}

int findLabel (char *name) {
	for (int i = 0; i < num_labels; ++i)
		if (!strcmp(labels[i].name, name))
			return i;
	
	return -1;
}

void addLabel (char *name, long pos) {
	if (num_labels >= max_labels - 1) {
		// Create additional labels
		max_labels *= 2;
		labels = (struct label *) realloc(labels, sizeof(struct label) * max_labels);
	}

	// Store the name of this label for lookup later
	labels[num_labels].name = strdup(name);

	// Remember the position in the file to come back to it
	labels[num_labels].pos = pos;

	num_labels++;
}

int findAsciz (char *name) {
	int i = 0;
	while (a[i].name)
		if (!strcmp(a[i].name, name))
			return i;

	return i;
}
