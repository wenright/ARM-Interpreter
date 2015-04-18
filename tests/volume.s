// Will Enright
// Controls LED brightness with potentiometer
.data

.balign 4
format: .asciz "%d\n"

.text

.global main

one:
	mov r0, #8			
	mov r1, #1
	bl digitalWrite		//Light LED connected to red wire

	mov r0, #23			
	mov r1, #0
	bl digitalWrite		//Light LED connected to yellow wire

	mov r0, #24			
	mov r1, #0
	bl digitalWrite		//Light LED connected to orange wire

	mov r0, #25			
	mov r1, #0
	bl digitalWrite		//Light LED connected to white wire

	mov r0, #100		//place 100 into r0
	bl delay			//wait 100 ms
	bl read 			//branch to top of label

two:
	mov r0, #8			
	mov r1, #1
	bl digitalWrite		//Light LED connected to red wire

	mov r0, #23			
	mov r1, #1
	bl digitalWrite		//Light LED connected to yellow wire

	mov r0, #24			
	mov r1, #0
	bl digitalWrite		//Light LED connected to orange wire

	mov r0, #25			
	mov r1, #0
	bl digitalWrite		//Light LED connected to white wire

	mov r0, #100		//place 100 into r0
	bl delay			//wait 100 ms
	bl read 			//branch to top of label

three:
	mov r0, #8			
	mov r1, #1
	bl digitalWrite		//Light LED connected to red wire

	mov r0, #23			
	mov r1, #1
	bl digitalWrite		//Light LED connected to yellow wire

	mov r0, #24			
	mov r1, #1
	bl digitalWrite		//Light LED connected to orange wire

	mov r0, #25			
	mov r1, #0
	bl digitalWrite		//Light LED connected to white wire

	mov r0, #100		//place 100 into r0
	bl delay			//wait 100 ms
	bl read 			//branch to top of label

four:
	mov r0, #8			
	mov r1, #1
	bl digitalWrite		//Light LED connected to red wire

	mov r0, #23			
	mov r1, #1
	bl digitalWrite		//Light LED connected to yellow wire

	mov r0, #24			
	mov r1, #1
	bl digitalWrite		//Light LED connected to orange wire

	mov r0, #25			
	mov r1, #1
	bl digitalWrite		//Light LED connected to white wire

	mov r0, #100		//place 100 into r0
	bl delay			//wait 100 ms
	bl read 			//branch to top of label
	

read:
	ldr r0, [sp]		//pop stack into r0
	bl readADC			//Read adc
	mov r4, #100		//move 100 to r4
	mul r1, r0, r4		//multiple r0 by r4, place result in r1
	lsr r1, r1, #10 	//Divide r1 by 1024
	mov r5, r1			//Place r1 in a reg that won't be affected by print
	ldr r0, =format		//Load format into r0
	bl printf 			//Print reading

	//Compare reading (r1) to determine which pins to set to 0/1
	cmp r5, #75
	bgt four
	cmp r5, #50
	bgt three
	cmp r5, #25
	bgt two
	cmp r5, #0
	bgt one

	//Since none of the above paths were taken, light none up
	mov r0, #8			
	mov r1, #0
	bl digitalWrite		//Light LED connected to red wire

	mov r0, #23			
	mov r1, #0
	bl digitalWrite		//Light LED connected to yellow wire

	mov r0, #24			
	mov r1, #0
	bl digitalWrite		//Light LED connected to orange wire

	mov r0, #25			
	mov r1, #0
	bl digitalWrite		//Light LED connected to white wire

	mov r0, #100		//place 100 into r0
	bl delay			//wait 100 ms
	bl read 			//branch to top of label

	

main:
	str lr, [sp, #-4]!

	add r0, r1, #4		//Load cml argument 1 into r0
	ldr r0, [r0]		//Load the value of address at r0 into r0
	bl atoi				//Convert the string to a number
	str r0, [sp, #-4]!	//push r0 onto the stack

	bl wiringPiSetup	//Setup wiring pi
	bl init				//Initialize wiring pi

	//RED
	mov r0, #8			//Set r0 to GPIO pin 8, red wire
	mov r1, #1 			//Set r1 to be OUTPUT
	bl pinMode			//Tell pin at r0 whether it's input or output

	//WHITE
	mov r0, #25			//Set r0 to GPIO pin 25, white wire
	mov r1, #1 			//Set r1 to be OUTPUT
	bl pinMode			//Tell pin at r0 whether it's input or output

	//YELLOW
	mov r0, #23			//Set r0 to GPIO pin 23, yellow wire
	mov r1, #1 			//Set r1 to be OUTPUT
	bl pinMode			//Tell pin at r0 whether it's input or output

	//ORANGE
	mov r0, #24			//Set r0 to GPIO pin 24, orange wire
	mov r1, #1 			//Set r1 to be OUTPUT
	bl pinMode			//Tell pin at r0 whether it's input or output

	bl read 			//Begin reading ADC loop
