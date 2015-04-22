.global main

test:
	mov r3, #100
	sub r1, r3, r1
	
	mov r7, #1
	swi 0		; Exit

main:
	mov r0, #8			
	mov r1, #7
	add r2, r1, r0	; Should be 15

	bl test
