#include <stdlib.h>

void push (int k);
int pop ();

struct node {
	struct node *prev;
	int val;
};

struct node *top;