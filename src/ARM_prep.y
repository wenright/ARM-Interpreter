%token <string> LABEL WORD QUOTE
%token NEWLINE GLOBAL COMMA ASCIZ

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
	ascii
|
	NEWLINE
;

label:
	LABEL {
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

ascii:
	ASCIZ QUOTE {
		addAscii($2);
	}
;

%%

// If an error is encountered when parsing, this function is invoked
void yyerror (char const *s) {
 	fprintf (stderr, "Pre-interpreter: %s\n\tPossible unknown identifier: \"%s\"\n\t%lu chars deep\n", 
 		s, cur_word, offset);
}

// Create a new label and add it to the list of labels
// This will be referenced when doing lookups later for branch calls
void addLabel (char *name, long pos) {
	// Store the name of this label for lookup later
	labels[num_labels].name = strdup(name);

	// Remember the position in the file to come back to it
	labels[num_labels].pos = pos;

	// Initialize variables for storing ascii strings
	labels[num_labels].max_strings = 5;
	labels[num_labels].num_strings = 0;
	labels[num_labels].strings = (char **) malloc(sizeof(char *) * labels[num_labels].max_strings);

	num_labels++;

	// Create additional labels if we have reached the limit
	if (num_labels == max_labels) {
		max_labels *= 2;
		labels = (struct label *) realloc(labels, sizeof(struct label) * max_labels);
	}
}

// Add the given string to the current label
// this string will be used in later printf calls
// Note that the string is duplicated, so should be free'd seperately
void addAscii (char *str) {
	// We can assume that there will be at least one label
	assert(num_labels > 0);

	labels[num_labels - 1].strings[labels[num_labels - 1].num_strings] = strdup(str);

	labels[num_labels - 1].num_strings++;

	// Create additional strings if the limit is reached
	if (labels[num_labels - 1].num_strings == labels[num_labels - 1].max_strings) {
		labels[num_labels - 1].max_strings *= 2;
		labels[num_labels - 1].strings = (char **) realloc(labels[num_labels - 1].strings,
			sizeof(char *) * labels[num_labels - 1].max_strings);
	}
}
