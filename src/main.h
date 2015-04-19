#ifndef MAIN_H
#define MAIN_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>	
#include <assert.h>
#include <stdint.h>

extern int zzparse (void);
extern int yyparse (void);

int findLabel(char *name);
void addLabel (char *name, long pos);
int findAsciz (char *name);

extern FILE *yyin;
extern FILE *zzin;

int num_labels = 0;
int max_labels = 10;

char *cur_word;

struct label {
	char *name;
	long pos;
};

struct label *labels;
struct label entry_point;

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

struct reg r[16];

// TODO allow for more asciz
struct asciz a[100];

#endif
