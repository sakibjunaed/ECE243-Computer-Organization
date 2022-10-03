.global _start
_start:

FIRST:		MOV R5, #0				//Same as part 2
LOOP:		LDR R8, =KEYBASE
			LDR	R11, [R8, #0xc]
			CMP R11, #1
			BGE STOP

			CMP R5, #99
			BEQ	FIRST
			ADD R5 , #1
			LDR R8, =0xFFFEC600		//r8 points to base register of timer
			LDR R1, =0x2FAF080		
			STR R1, [R8]			//50000000 into data resgister
			MOV R1, #1				
			STR R1, [R8, #0x8]		//set enable bit in contol resgiter to 1
	
CONT:		LDR R1, [R8, #0xc]
			CMP R1, #1				//check if f bit in interrupt status register is 1
			BLT CONT
			MOV R1, #1				//if timer hit 0 then reset f bit
			STR R1, [R8, #0xc]
			B DISPLAY
			
STOP:		MOV R12, #15			
			STR R12, [R8, #0xc]
			B WAIT
			
WAIT:		LDR R1, [R8]
			CMP R1, #1
			BLT WAIT
			B CONT1
CONT1:       LDR R1, [R8]
			CMP R1, #1
			BGE	CONT1
			MOV R12, #15
			STR R12, [R8, #0xc]
			B   LOOP
			
			
DISPLAY:	LDR R8, =0xFF200020   
			
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
			
DIVIDE:     MOV    R2, #0
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