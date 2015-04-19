#include "main.h"

int main(int argc, char **argv) {
	if (argc == 1) {
		// TODO usage printout
		printf("Too few arguments, exiting\n");
		exit(1);
	}
	else if (argc > 2) {
		printf("Too many arguments, exiting\n");
		exit(1);
	}

	// Load selected file as input
	if ((zzin = yyin = fopen(argv[argc - 1], "r")) == NULL) {
		perror("fopen");
		return 1;
	}

	// Create initial empty list of labels
	labels = (struct label *) malloc(sizeof(struct label) * max_labels);

	// First preprocess the file and add all labels to the list
	zzparse();

	// Reset the file to the beginning, or the entry point if there is one
	if (entry_point.pos < 0)
		fseek(yyin, 0, SEEK_SET);
	else
		fseek(yyin, entry_point.pos, SEEK_SET);

	printf("Entry point: %lu\n", entry_point.pos);

	// TODO Free labels here?
	// Print out all of the labels that we have found, for debugging purposes
	printf("\n--- Labels Found ---\n");
	for (int i = 0; i < num_labels; ++i) {
		printf("label %d: name=%s\n", i, labels[i].name);
		free(labels[i].name);
	}
	printf("--------------------\n\n");

	// Next, parse file, executing lines iteratively
	yyparse();

	return 0;
}


