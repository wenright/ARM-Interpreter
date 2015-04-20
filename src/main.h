#ifndef MAIN_H
#define MAIN_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>	
#include <assert.h>
#include <stdint.h>

#include "stack.h"

extern int zzparse (void);
extern int yyparse (void);

int findLabel(char *name);
void addLabel (char *name, long pos);
int findAsciz (char *name);

long int offset = 0;

extern FILE *yyin;
extern FILE *zzin;

int num_labels = 0;
int max_labels = 10;

char *cur_word;

struct label {
	char *name;
	long pos;

	char **strings;
	int num_strings;
	int max_strings;
};

struct label *labels;
struct label entry_point;

int r[16];

int cmp[2];

#endif
