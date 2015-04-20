#ifndef ARM_INTERP_H
#define ARM_INTERP_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>	
#include <assert.h>
#include <stdint.h>

#include "stack.h"

void yyerror(const char * s);
int yylex();
void clear_buffer();

void addLabel (char *name, long pos);
void addAscii (const char *str);
void jump_to(const char *name);

extern FILE *yyin;
extern long int offset;
extern int cur_line;

extern char *cur_word;

extern int num_labels;
extern int max_labels;

struct label {
	char *name;
	long pos;

	char **strings;
	int num_strings;
	int max_strings;
};

extern struct label *labels;
extern struct label entry_point;

extern int r[16];

extern int cmp[2];

#endif