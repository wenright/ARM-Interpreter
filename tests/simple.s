.global main

main:
	mov r0, #8			
	mov r1, #7
	add r2, r1, r0	; Should be 15

	bl test

test:
	mov r3, #100
	sub r1, r3, r1
