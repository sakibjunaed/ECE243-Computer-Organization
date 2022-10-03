.global _start
_start:

FIRST:		MOV R5, #0			//Initialize ocunter value to 0
LOOP:		LDR R8, =KEYBASE	//R8 points to base register
			LDR	R11, [R8, #0xc]	//load edge capture register
			CMP R11, #1			//check if edge capture bit is 1
			BGE STOP			//if button pressed branch
			CMP R5, #99			//check if reached 99
			BEQ	FIRST			//if reached 99, go back to start
			ADD R5 , #1			//increment
			
DO_DELAY: 	LDR R7, =500000 // for CPUlator use =500000
SUB_LOOP: 	SUBS R7, R7, #1	//decrement the number
		  	BNE SUB_LOOP	//keep decrementing until reach 0
			BL DISPLAY		//after reaching zero branch to display
			B LOOP			//go back to start
			
			
STOP:		MOV R12, #15	
			STR R12, [R8, #0xc]		//reset edge capture register by wrting ones
			B WAIT					//branch to wait
			
WAIT:		LDR R1, [R8]			
			CMP R1, #1				//check if a button has been pressed to resume
			BLT WAIT
			B CONT
CONT:       LDR R1, [R8]			//check if a button has been released
			CMP R1, #1
			BGE	CONT
			MOV R12, #15
			STR R12, [R8, #0xc]		//reset edge cap 
			B   LOOP				//go back to start

DISPLAY:	LDR R8, =0xFF200020   	//display subroutine from previous lab
			
			MOV R0, R5            
			MOV R1, #10           
			BL DIVIDE             
			
			MOV R9, R1           
			BL  SEG7_CODE         
			MOV R4, R0            
			MOV R0, R9            
			
			BL SEG7_CODE          
			LSL R0, #8            
			ORR R4, R0	          
			
			STR R4, [R8]
			B 	LOOP
			
DIVIDE:     MOV    R2, #0			//divide subroutine from lab1
CONT4:       CMP    R0, R1
            BLT    DIV_END
            SUB    R0, R1
            ADD    R2, #1
            B      CONT4
DIV_END:    MOV    R1, R2     
            MOV    PC, LR
			

.equ KEYBASE, 0xff200050

SEG7_CODE: MOV R1, #BIT_CODES
			ADD R1, R0 // index into the BIT_CODES "array"
			LDRB R0, [R1] // load the bit pattern (to be returned)
			MOV PC, LR

BIT_CODES: .byte 0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
			.byte 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111

          .end  