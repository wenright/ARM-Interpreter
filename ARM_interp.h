#include <stdio.h>
#include <stdlib.h>
#include <string.h>	
#include <assert.h>
#include <stdint.h>

void yyerror(const char * s);
int yylex();

int findLabel(char *name);

extern FILE *yyin;

int num_labels = 0;
int max_labels = 10;

struct label {
	char *name;
	// fpos_t pos;
	long pos;
};

struct reg {
	char type;
	union {
		char *str_val;
		int int_val;
	};
};

struct reg r[16];

struct label *labels;