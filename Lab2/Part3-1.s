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

NUM:       .word  0x55555555    //alternating 1s and 0s for XOR

TEST_NUM: .word   0x2AAA0E   // 15 alternate, 10 zeros, 3 ones
		  .word   0x15555FFF // 18 alternate, 3 zeros, 13 ones 
		  .word	  0x7FF      // 2 alternate, 21 zeros, 11 ones
		  .word   0
		  

          .end                            