.global _start
_start:
		

			
KEYSTART:	LDR r8, =KEYBASE //load into r8 base address of keys
			LDR R1, [R8] 	//load value of base into r1
			CMP R1, #1		//check if no button pressed
			BLT KEYSTART    //if no button pressed keep polling
			B 	WAIT1       //if pressed branch
		
WAIT1:		LDR R1, [R8]    //load into r1 the data register
			CMP R1, #1      //check if button is released
			BGE WAIT        //if not released keep polling
			LDR R4, =0xFF200020 //r4 points base address of hex0-3
			MOV R0,#0           //pass 0 to subroutine
			BL  SEG7_CODE       //get code for 0
			STR R0, [R4]        //display 0 in hex 0
			B START             //branch

			
START:		LDR R1, [R8]        //load data register
			AND R2, R1, #1      //isolate first 4 bits
			AND R3, r1, #2
			AND R4, r1, #4
			AND R5, r1, #8
			
			CMP R2, #1			//check if key0 pressed
			BEQ KEY0P
			CMP R3, #2          //check if key1 pressed
			BEQ KEY1P
			CMP R4, #4          //check if key2 pressed
			BEQ KEY2P
			CMP R5, #8          //check if key3 pressed
			BEQ KEY3P
			B START             //keep polling if nothing pressed
			
KEY0P:		LDR R1, [R8]        //load data register
			CMP R1, #1          //check if released
			BEQ KEY0P           //keep polling if not released
			MOV R6, #0          
			MOV R0, #0			
			BL SEG7_CODE		//get code for 0
			LDR R4, =0xFF200020
			STR R0, [R4]		//display 0
			B	START           //go back to polling
			
KEY1P: 		LDR R1, [R8]
			CMP R1, #2			//check if released
			BEQ KEY1P
			
			CMP R6, #9			//check if max digit 9 is reached
			BEQ START           //if hit 9, go back to polling
			ADD R6, #1			//increment
			MOV R0, R6
			MOV R1, #0			//pass digit to subroutine
			BL SEG7_CODE		//get code for digit
			LDR R4, =0xFF200020
			STR R0, [R4]		//display digit
			B START				//poll again
			
KEY2P:		LDR R1, [R8]		
			CMP R1, #4			//check if released
			BEQ KEY2P
			CMP R6, #1			//check if 1 reached
			BLT START			//if 1 then poll again
			SUB R6, #1			//decrement
			MOV R0, R6
			MOV R1, #0
			BL SEG7_CODE		//get digit code
			LDR R4, =0xFF200020
			STR R0, [R4]		//display number
			B START
			
KEY3P:      LDR R1, [R8]		//check if released
			CMP R1, #8
			BEQ KEY3P
			MOV R6, #0
			LDR R4, =0xFF200020
			STR R12, [R4]		//clear display by loading 0
			B KEY30

KEY30:		LDR R1, [R8]		
			CMP R1, #1
			BLT KEY30				//check if any button pressed after key3 released
			B 	WAIT
		
WAIT:		LDR R1, [R8]			//check if released
			CMP R1, #1
			BGE WAIT
			LDR R4, =0xFF200020
			MOV R0,#0
			BL  SEG7_CODE
			STR R0, [R4]			//display zero
			B START
			

		

.equ KEYBASE, 0xff200050
SEG7_CODE: MOV R1, #BIT_CODES
			ADD R1, R0 // index into the BIT_CODES "array"
			LDRB R0, [R1] // load the bit pattern (to be returned)
			MOV PC, LR
			

BIT_CODES: .byte 0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
			.byte 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111		
		
		
	