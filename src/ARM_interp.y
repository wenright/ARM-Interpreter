%token <string> WORD FORMAT LABEL QUOTE
%token <number> NUMBER REGISTER
%token COMMA HASH NEWLINE 
%token GLOBAL MOV CMP LDR ADD SUB MUL BL BLT BLE BGT BGE PRINTF
	 ASCIZ PUSH POP CLOSEBRACE OPENBRACE SWI

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
	ascii
|
	NEWLINE

;

// We can ignore these, they have already been cached
label:
	LABEL
|
	GLOBAL WORD
;

expression:
	MOV REGISTER COMMA argument {
		r[$2] = $4;
	}
|
	LDR REGISTER COMMA FORMAT {
		r[$2] = findLabel($4);
	}
|
	ADD REGISTER COMMA argument COMMA argument {
		r[$2] = $4 + $6;
	}
|
	SUB REGISTER COMMA argument COMMA argument {
		r[$2] = $4 - $6;
	}
|
	MUL REGISTER COMMA argument COMMA argument {
		r[$2] = $4 - $6;
	}
|
	BL PRINTF {
		// TODO printf format
		// TODO "Conditional jump or move depends on uninitialised value"
		for (int i = 0; i < labels[r[0]].num_strings; i++)
			puts(labels[r[0]].strings[i]);
	}
|
	BL WORD {
		jump_to($2);
	}
|
	CMP REGISTER COMMA argument {
		// TODO set flags based on eq, lt, gt, etc...
		// Alternatively, do nothing and compute later in BGT etc
		cmp[0] = r[$2];
		cmp[1] = $4;
	}
|
	BGT WORD {
		if (cmp[0] > cmp[1])
			jump_to($2);
	}
|	
	BGE WORD {
		if (cmp[0] >= cmp[1])
			jump_to($2);
	}
|
	BLT WORD {
		if (cmp[0] < cmp[1]) 
			jump_to($2);
	}
|
	BLE WORD {
		if (cmp[0] <= cmp[1]) 
			jump_to($2);
	}
|	
	SWI NUMBER {
		// Invoke a system call
		// Command depends on what is in r7
		// 1 -> exit(), 4 -> write(), etc.
		switch (r[7]) {
			case 1:
				exit(r[0]);
				break;
			default:
				// Case hasn't been created yet
				break;
		}
	}
|
	PUSH OPENBRACE REGISTER CLOSEBRACE {
		push(r[$3]);
	}
|
	POP OPENBRACE REGISTER CLOSEBRACE {
		r[$3] = pop();
	}
|
	PUSH OPENBRACE REGISTER COMMA REGISTER CLOSEBRACE {
		// TODO
	}
|
	POP OPENBRACE REGISTER COMMA REGISTER CLOSEBRACE {
		// TODO
	}
;

argument:
	REGISTER {
		$$ = r[$1];
	}
|
	HASH NUMBER {
		$$ = $2;
	}
;

ascii:
	ASCIZ QUOTE
;

%%

void yyerror(const char * s) {
	fprintf(stderr,"\nInterpreter: %s\n\tPossible unknown identifier: \"%s\"\n\t%lu chars deep\n", 
		s, cur_word, offset);
}

int findLabel (const char *name) {
	for (int i = 0; i < num_labels; ++i)
		if (!strcmp(labels[i].name, name))
			return i;
	
	return -1;
}

// Set the current file to pos
void jump_to (const char *name) {
	// Branch to 'name'
	int label_index = findLabel(name);

	// label_index will be -1 if search fails, implying this label doesn't exist
	assert(("Label not found", label_index >= 0));

	// The offset is just for debugging purposes
	offset = labels[label_index].pos;

	// Reset yyin to be at the starting position of the label
	fseek(yyin, labels[label_index].pos, SEEK_SET);

	clear_buffer();
}