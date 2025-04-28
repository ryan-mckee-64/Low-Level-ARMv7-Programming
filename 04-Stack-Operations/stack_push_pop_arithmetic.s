@CHALLENGE: 
@- SET UP TWO VALUES IN MEMORY
@- LOAD THEM USING ADDRESSING
@- PUSH THEM ONTO THE STACK
@- POP THEM BACK INTO REGISTERS
@- PERFORM ADDITION WITH "ADDS" TO SET FLAGS
@- USE "ADC" TO HANDLE CARRY
@- PERFORM SUBTRACTION WITH "SUBS" TO SET FLAGS
@- MULTIPLY THE RESULTS
@- APPLY LOGICAL "AND", "ORR", "EOR" ON THE RESULTS
@- STORE FINAL VALUES BACK INTO MEMORY
-------------------------------------------------------------------------------

@BEGIN CODING
.global _start 
_start: 
	LDR R0,=list 
	LDR R1,[R0],#4 
	LDR R2,[R0],#4 
	PUSH {R1,R2} @stack pointer = sp - 8-bytes , data written to R1/R2 are pushed to the stack
	POP {R1,R2} @stack pointer = sp - 8-bytes + 8-bytes = original sp / registers R1/R2 are popped back out from the stack
	ADDS R3,R2,R1 @performing the addition of data from R2/R1 and storing inside of R3, meanwhile setting a cpsr flag to handle a carry-over, cpsr is updated to "1" if carry happens, otherwise "0"
	ADC R3,R2,R1 @should a carry-over happen, addition is repeated except with the addition of the carry, R3=R2+R1+carry, cpsr reverts back after carry is taken and used by the "ADC" operator, then we store in R3. carry -> [cpsr 200001d3] 
	SUBS R4,R2,R1 @performing subtraction with SUBS on our integers from stack list, meanwhile setting a cpsr flag to handle a negative if the subtraction results in a negative, the result is stored in R4. negative -> [cpsr 800001d3] 
	MUL R5,R3,R4 @performing multiplication with MUL with our two previous results, which were written to R3 and R4, and then writing the result to register 5

	AND R3,R4,R5 @and result stored in reg3, used from the result of SUBS and MUL that were stored in registers R4/R5
	ORR R2,R4,R5 @orr result stored in reg2, used from the result of SUBS and MUL that were stored in registers R4/R5
	EOR R1,R4,R5 @eor result stored in reg1, used from the result of SUBS and MUL that were stored in registers R4/R5

	@now write the logical operator results back to the stack, i'll just do it using individual stack data storage, to make it sequentially after our original list

	STR R3,[R0],#4 @storing add result from reg3 at current reg0 pointer address, because we did a post increment earlier, so we are now at the third entry in the list
	STR R2,[R0],#4 @storing orr result from reg2 at the now incremented pointer address, that data was written to the 4th entry of the list within the stack
	STR R1,[R0] @storing eor result from reg1 at the now 5th entry within our list in the stack memory, no need to perform post-increment as we have finished our task!

	@but I believe it could also be written to the stack simply using the PUSH operator, like this:
	@PUSH {R1,R2,R3} @stack pointer updated -> sp - 12-bytes to accomodate for pushing 3 registers on a 32 bit processing unit

	//Optional -> End program cleanly

	MOV R7,#1 @moving decimal #1 into special functionality register (R7)
	SWI 0 @calling operating system via a software interrupt, program is then terminated


.data
list:
	.word 14, 7

	@To be clear, i am not sure what you meant by perform logical operators on "the results" so I just took the results of the SUBS and ADC and multiplied them, then saved accordingly
