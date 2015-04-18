.global main

main:
	ldr r0, =hello
	bl printf

hello:
	.asciz "Hello World\n"