@CHALLENGE: DEMONSTRATE AND CORRECTLY IMPLEMENT EVERY MAJOR ARMv7 ADDRESSING MODE (IMMEDIATE, REGISTER-DIRECT, LITERAL, INDIRECT, INDIRECT+OFFSET, PRE-INCREMENT, POST-INCREMENT) USING MOV AND LDR.

.global _start @DEFINING GLOBAL REFERENCE TO THE "START:" LABEL
_start: @DEFINING START LABEL SO THAT THE CPU KNOWS WHERE EXECUTION BEGINS
	MOV R0,#30 @USING "MOV" OP-CODE TO IMMEDIATE ADDRESS REGISTER 0, LOADING DECIMAL VALUE "30" ONTO IT
	MOV R1,R0 @DIRECT REGISTER ADDRESSING REGISTER 1, COPYING CONSTANT VALUE "30" ONTO REGISTER 1 FROM REGISTER 0
	LDR R2,=list @LITERAL ADDRESSING REGISTER TWO, SETTING THE POINTER TO THE STACK MEMORY ADDRESS OF THE FIRST ENTRY OF OUR LIST
	LDR R3,[R2] @USING INDIRECT ADDRESSING TO LOAD THE CONTENTS ASSOCIATED WITH THE STACK ADDRESS FROM THE POINTER IN REGISTER 2
	LDR R4,[R2,#4] @USING INDIRECT ADDRESSING + 4-BYTE OFFSET TO MOVE TO THE SUBSEQUENT MEMORY ADDRESS TO THE FIRST ENTRY ON THE LIST IN ORDER TO WRITE "2" ONTO R3
	LDR R5,[R2,#8]! @NOW USING PRE-INCREMENT ADDRESSING, THE BASE REGISTER "R2" WILL OFFSET 8-BYTES TO THE THIRD STACK MEMORY ADDRESS IN OUR LIST, INCREMENT THAT ADDRESS TO OUR BASE REGISTER, MAKING THE POINTER NOW "R2 + 8-BYTES", AND THEN WRITE THE CONTENTS AT THAT STACK MEMORY ADDRESS TO REGISTER 5
	LDR R6,[R2],#4 @NOW USING POST-INCREMENT ADDRESSING, SINCE THE BASE POINTER WAS UPDATED TO "R2+8" FROM THE PREVIOUS PRE-INCREMENT, WE ARE NOW OFFSETTING BY 4-BYTES TO GO TO THE FOURTH MEMORY STACK ADDRESS WITHIN OUR LIST, WE WILL ACCESS AND WRITE THE CONTENTS OF THAT MEMORY ADDRESS TO REGISTER 6, AND THEN INCREMENT BY 4-BYTES

.data @CREATING A PARTITION WITHIN STACK MEMORY ALLOCATED FOR OUR LIST
list: @LABEL FOR OUR LIST CREATED AND CLEARLY DEFINED AS "LIST:"
	.word 1,2,3,4,5,6 @LENGTH FOR EACH SUBSEQUENT ENTRY IN THE LIST HAS BEEN DEFINED AS ONE "WORD", WE ARE OPERATING ON A 32-BIT PROCESSOR, SO EACH NUMBER WILL BE 32-BITS IN LENGTH
