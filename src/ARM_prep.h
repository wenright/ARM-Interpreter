#ifndef ARM_PREP_H
#define ARM_PREP_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>	
#include <assert.h>
#include <stdint.h>

int yylex(void);
void yyerror(const char *);

int findLabel(char *name);

extern FILE *yyin;

extern long yyleng;
extern long int offset;

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

#endif