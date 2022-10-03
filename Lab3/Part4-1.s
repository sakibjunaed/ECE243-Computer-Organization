.global _start
_start:
	
FIRST1:	    MOV R12, #0				//set seconds to zero
FIRST:		MOV R5, #0				//set hundreths of seconds to zero
LOOP:		LDR R8, =KEYBASE		//r8 gets base register for keys
			LDR	R11, [R8, #0xc]		//load edge cap into r11
			CMP R11, #1				
			BGE STOP				//check if button has been pressed and released
			CMP R5, #99				//check if hundreths of seconds hits 99
			BEQ FIRST2				//set back to zero if so
			ADD R5, #1				//else increment
			LDR R8, =0xFFFEC600		//r8 points to base regsiter of timer
			LDR R1, =0x1E8480		//load 2000000 into timer
			STR R1, [R8]	
			MOV R1, #1				//set enbale bit to 1 
			STR R1, [R8, #0x8]

CONT:		LDR R1, [R8, #0xc]		
			CMP R1, #1				//load interrupt status
			BLT CONT				//check if f bit in interrupt status is 1
			MOV R1, #1				
			STR R1, [R8, #0xc]		//reset f bit
			B DISPLAY

STOP:		MOV R10, #15			
			STR R10, [R8, #0xc]
			B WAIT
			
WAIT:		LDR R1, [R8]			//wait for button pressed
			CMP R1, #1
			BLT WAIT
			B CONT1
CONT1:       LDR R1, [R8]			//wait for button release
			CMP R1, #1
			BGE	CONT1
			MOV R10, #15
			STR R10, [R8, #0xc]
			B   LOOP
	

FIRST2: 	CMP R12, #59			//check if seconds hits 59
			BEQ FIRST1				//if hits 59 then reset to 0
			ADD R12, #1				//else increment
			B 	FIRST				//go back to start
			
		
DISPLAY:	LDR R8, =0xFF200020   	//display subroutine
			
			MOV R0, R5            //load hundredths digits
			MOV R1, #10           
			BL DIVIDE             
			
			MOV R9, R1           
			BL  SEG7_CODE         
			MOV R4, R0            
			MOV R0, R9            
			
			BL SEG7_CODE          
			LSL R0, #8            
			ORR R4, R0	
			
			MOV R0, R12				//load seconds digits
			MOV R1, #10
			BL DIVIDE
			
			MOV R9, R1
			BL SEG7_CODE
			LSL R0, #16		
			ORR R4, R0
			MOV R0, R9
			
			BL SEG7_CODE
			LSL R0, #24
			ORR R4, R0
			
			STR R4, [R8]			//display time
			B 	LOOP
			
DIVIDE:     MOV    R2, #0			//divide subroutine
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