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
	zzin = yyin = fopen(argv[argc - 1], "r");
	if (zzin == NULL || yyin == NULL) {
		perror("fopen");
		return 1;
	}

	// Create initial empty list of labels and ascii_labels
	labels = (struct label *) malloc(sizeof(struct label) * max_labels);

	// First preprocess the file and add all labels to the list
	zzparse();

	// Reset the file to the beginning, or the entry point if there is one
	if (entry_point.pos < 0)
		fseek(yyin, 0, SEEK_SET);
	else
		fseek(yyin, entry_point.pos, SEEK_SET);

	offset = 0;

	// Next, parse file, executing lines iteratively
	yyparse();
	fclose(yyin);

	// TODO free labels names as well
	free(labels);

	return 0;
}