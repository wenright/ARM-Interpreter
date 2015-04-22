// Takes in two numbers as input and prints the largest

.global main

main:
	// Get input for first number
	ldr r0, =.input		// Move str to rdi
	bl scanf
	mov r12, r0		// Move value to r12

	// Get input for the second number
	ldr r0, =.input		// Move str to rdi
	bl scanf
	mov r13, r0		// Move value to r12

	// Prepare the largest number to be printed
	ldr r0, =.output		// Move output to r0

	// Compare the numbers, and branch if the second is larger
	cmp r13, r12		// Compare the two inputted numbers
	bgt second		// Branch to second if greator or equal

	// Print the largest number
	mov r1, r12		// Move r12 contents to rsi
	bl printf

	// Exit program
	mov r7, #1
	swi 0

second:
	// Assign the largest output and print it
	mov r1, r13
	bl printf	

	// Exit program
	mov r7, #1
	swi 0

.input:
	.ascii "%d\0"
.output:	
	.ascii "%d\n\0"
