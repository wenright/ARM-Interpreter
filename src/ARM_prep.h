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
void addLabel (char *name, long pos);
int findAsciz (char *name);

extern FILE *yyin;

extern long yyleng;
extern long int offset;

extern char *cur_word;

extern int num_labels;
extern int max_labels;

struct label {
	char *name;
	long pos;
};

extern struct label *labels;
extern struct label entry_point;

struct reg {
	char type;
	union {
		char *str_val;
		int int_val;
	};
};

struct asciz {
	// TODO allow for more constants
	char *strings[10];
	int strings_i;

	char *name;
};

extern struct reg r[16];

// TODO allow for more asciz
extern struct asciz a[100];

#endif