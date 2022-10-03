/* Program that counts consecutive 1's */

          .text                   // executable code follows
          .global _start                  
_start:                             
          MOV     R6, #TEST_NUM   // r6 points to first number
          LDR     R1, [R6]        // load first number into r1
		  
		  MOV 	  R4, #0          
		  
MAIN:	  CMP     R1, #1          //Check for zero
		  BLT	  P				  //if zero branch to P
		  BL      ONES            //Call subroutine ONE
		  CMP     R4, R0          //Compare subroutine result to current largest
		  BLT 	  C               //If result is larger branch to C
CONT:	  ADD     R6, #4          //r6 points to next number
		  LDR     R1, [R6]        //load next number into r1
		  B 	  MAIN            //Loop again

C:		  MOV 	  R4, R0          //move largest one into r4
		  B       CONT            //go back to loop
		  
P:		  MOV     R5, R4          //move largest into r5
		  
END:      B       END             //end program
		  
ONES:	  MOV 	  R3, #0		 //r3 counts the largest sequence
LOOP:     CMP     R1, #0         //check for zero 
          BEQ     DONE           //branch to DONE if finished
          LSR     R2, R1, #1     //Shift R1 to the right by 1 bit and store in R2 
          AND     R1, R1, R2     //Logical "AND" R1 and R2 and store in R1
          ADD     R3, #1         //Increment the counter 
          B       LOOP           //Loop again
DONE: 	  	mov r0, r3           //Move result into r0
 			mov pc, lr           //Return

             

TEST_NUM: .word   0x2000001      //List of numbers
		  .word	  0x2000003
		  .word   0x2000007
		  .word   0x2000007
		  .word   0x200001F
		  .word   0x2000FFF
		  .word   0x200001F
		  .word   0x2007FFF //Largest: 15 ones
		  .word   0x2000003
		  .word   0x2000001
		  .word   0
          .end                            