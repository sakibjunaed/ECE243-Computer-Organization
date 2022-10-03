/* Program that counts consecutive 1's */

          .text                   // executable code follows
          .global _start                  
_start:                             
          MOV     R6, #TEST_NUM   //R6 points to start of list
          LDR     R1, [R6]        //load first number into r1
		  
		  MOV 	  R4, #0          
		  MOV     R10, #0
		  MOV     R12, #0
		  
		  
MAIN:	  CMP     R1, #0          //check for zero
		  BEQ	  P				  //if zero branch to P
		  BL      ONES            //call ONES subroutine
		  BL      ZEROS           //call ZEROS subroutine
		  BL      ALTERNATE       //call alternate subroutine
		  MOV     R9, R11         //save result in r9
		  MVN     R1, R1          //invert the current number
		  BL 	  ALTERNATE       //call alternate again (counting zeros)
		  CMP     R4, R0          //compare current largest sequence with result of ONES 
		  BLT 	  C				  //if result is bigger branch to C

CONT1:    CMP     R10, R2         //compare current largest sequence with ZEROS result
		  BLT     D               //if result is bigger branch to D

CONT2:    CMP     R12, R9         //compare current largest sequence with ALTERNATE result
		  BLT     E				  //if result is bigger branch to E
		  B       CONT3           //if result is not bigger branch to CONT3

CONT3:    CMP     R12, R11        //Compare current largest sequence with alternate result
		  BLT     F               //if result is bigger branch to F
		  B       CONT            //Done comparisons  

CONT:	  ADD     R6, #4          //r6 points to next number
		  LDR     R1, [R6]        //r1 gets next number
		  B 	  MAIN            //branch back to main loop

C:		  MOV 	  R4, R0          //Move current largest ONES seuqence into r4
		  B       CONT1           //Branch
		  
D:        MOV     R10, R2         //Move current largest ZEROS sequence into r10
		  B       CONT2           //Branch
		  
E:        MOV     R12, R9         //Move current largest ALTERNATE (using ones) to r12
		  B       CONT3           //Branch
		 
F:        MOV     R12, R11        //Move current largest ALTERNATE (using zeros) to R12
		  B       CONT            //Branch
		  
P:		  MOV     R5, R4          //Move largest ONES sequence into R5
		  MOV     R6, R10         //Move largest ZEROS sequence into R6
		  MOV     R7, R12         //Move largest ALTERNATE sequence into R7
		  
DISPLAY:	LDR R8, =0xFF200020   //Base address of hex3-hex0
			MOV R0, R5            //move ones sequence into r0
			MOV R1, #10           //set divisor to separate 2 digits
			BL DIVIDE             //branch to divide
			
			MOV R9, R1            //save tens digit in r9
			BL  SEG7_CODE         //branch to seg7_code
			MOV R4, R0            //move hex code for the ones digit into r4
			MOV R0, R9            //move tens digit into r0
			 
			BL SEG7_CODE          //branch to seg7_code
			LSL R0, #8            //logical shift left by 8 bits
			ORR R4, R0            //bitwise OR r4 and r0, store in r4
			
			MOV R0, R6            //move zeros sequence into r0
			MOV R1, #10           //set divisor
			BL DIVIDE             //branch to divide
			
			MOV R9, R1            //move tens digit into r1
			BL SEG7_CODE          //branch to seg7_code
			LSL R0, #16           //logical shift left by 16 bits 
			ORR R4, R0            //bitwise OR r4 and r0, store in r4
			
			MOV R0, R9            //save tens digit in r9
			BL SEG7_CODE          //branch to seg7_code
			LSL R0, #24           //logical shift left by 24 bits
			ORR R4, R0            //bitwise OR r4 and r0, store in r4
			
			STR R4, [R8]          //display ONES in hex1-0 ZEROS in hex3-2 
			
			LDR R8, =0xFF200030   //base address of hex5-4
			
			MOV R0, R7            //get alternate number
			MOV R1, #10           //set divisor
			BL DIVIDE             //branch to divide
			
			MOV R9, R1            //save tens digit
			BL  SEG7_CODE         //branch to seg7_code
			MOV R4, R0            //move code into r4
			MOV R0, R9            //get tens digit
			
			BL SEG7_CODE          //branch to seg7_code
			LSL R0, #8            //logical shift left by 8
			ORR R4, R0	          //bitwise OR r4 and r0, store in r4
			
			STR R4, [R8]          //display ALTERNATE number in hex5-4
			
		  	  
END:      B       END            //end program
		  
ONES:	  MOV 	  R3, #0		  //r3 counts seuquence
		  MOV     R7, R1          //copy current number into r7
LOOP:     CMP     R7, #0          //loop counter
          BEQ     DONE            //branch if done 
          LSR     R8, R7, #1      //logical shift right r7 by 1 and store in r8
          AND     R7, R7, R8      //bitwise AND r7 and r8 store in R7
          ADD     R3, #1          //increment counter
          B       LOOP            //Loop
DONE: 	  	mov r0, r3            //move result into r0
			mov pc, lr		      //return

ZEROS:    MOV R3, #0              //loop counter
		  MOV R7, R1              //copy current number into r7
		  MVN R7, R7              //invert number to count zeros
LOOP2:    CMP     R7, #0          //same functionality as ONES
          BEQ     DONE2           
          LSR     R2, R7, #1      
          AND     R7, R7, R2      
          ADD     R3, #1          
          B       LOOP2
DONE2: 	  mov r2, r3            
		  mov pc, lr		      

ALTERNATE: MOV R3, #0            //loop counter
		   MOV R7, R1			 //copy current number into r7
		   LDR R11, #NUM         //load alternating number into r11
		   EOR R7, R11           //XOR the 2 numbers
LOOP3:     CMP     R7, #0         //same functionality as ONES
          BEQ     DONE3            
          LSR     R8, R7, #1      
          AND     R7, R7, R8      
          ADD     R3, #1          
          B       LOOP3
DONE3: 	  	mov r11, r3            
			mov pc, lr		      
			
DIVIDE:     MOV    R2, #0
CONT4:       CMP    R0, R1
            BLT    DIV_END
            SUB    R0, R1
            ADD    R2, #1
            B      CONT4
DIV_END:    MOV    R1, R2     
            MOV    PC, LR

SEG7_CODE: MOV R1, #BIT_CODES
			ADD R1, R0 // index into the BIT_CODES "array"
			LDRB R0, [R1] // load the bit pattern (to be returned)
			MOV PC, LR

NUM:       .word  0x55555555    //alternating 1s and 0s for XOR

TEST_NUM: .word   0x2AAA0E   // 15 alternate, 10 zeros, 3 ones
		  .word   0x15555FFF // 18 alternate, 3 zeros, 13 ones 
		  .word	  0x7FF      // 2 alternate, 21 zeros, 11 ones
		  .word   0

BIT_CODES: .byte 0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
			.byte 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111

          .end                            