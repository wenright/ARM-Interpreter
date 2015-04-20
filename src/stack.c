#include "stack.h"

#include <stdio.h>

void push (int k) {
	struct node *n = (struct node *) malloc(sizeof(struct node));
	
	n->prev = top;
	n->val = k;
	top = n;
}

int pop () {
	int k = top->val;
	struct node *t = top;
	top = top->prev;
	free(t);
	return k;
}
