@CHALLENGE: LOAD TWO INTEGERS FROM MEMORY, PERFORM "ADDS" TO SET CPSR FLAGS, USE ADC IF CARRY OCCURS, PERFORM "SUBS", AND STORE RESULTS BACK INTO MEMORY

@RUN 1 / NO HELP / NO IDE / STRAIGHT FROM THE DOME

.global _start @defining a global reference to "_start:" label for program
_start: @implementing "_start:" label in order to tell the program where code execution is meant to begin
	
	@SECTION 1 -> LOADING REGISTERS FROM STACK MEMORY
	LDR R0,=list @utilizing "literal addressing" in order to create our base-registers pointer, this will be to the beginning of our list within the stack
	LDR R1,[R0],#4 @using post-increment addressing to write the contents from our base registers pointer into register 1, and then incrementing the pointer by 4-bytes, storing integer "a" in R1
	LDR R2,[R0],#4 @using post-increment addressing to write the contents from our updated pointers memory location, so this is the second entry within our list (integer "b"), we stored integer "b", then incremented again by 4-bytes in order to store our results later

	@SECTION 2 -> PERFORMING "ADDS" AND "ADC" OPERATIONS TO ADD THE DESIRED REGISTERS, AND HANDLE A CARRY VIA THE CPSR REGISTER
	ADDS R3,R1,R2 @now performing "ADDS" arithmetic op-code, this adds the contents from registers r1/r2 and writes them to register r3, should a carry happen, our cpsr register will be updated to a "1", for the ADC in the later line
	ADC R3,R1,R2 @should a carry occur when adding, the ADC operator will now take the original result of the addition, and add the carried out "1" from the cpsr to the result, thus giving us our desired result from addition written into R3, then the cpsr will be updated accordingly
	@should a carry out be flagged, the cpsr will look something like this [cpsr -> X00001d3] -> with the amount of bits overflowed shown by the "X" (not entirely sure, just a guess), our result is now written into register 3 (R3)

	@SECTION 3 -> PERFORMING "SUBS" OPERATION TO GET THE DIFFERENCE FROM THE DESIRED WRITTEN REGISTERS, AND FLAGGING THE CPSR IF OUR RESULT IS A NEGATIVE
	SUBS R4,R1,R2 @now performing the "SUBS" arithmetic op-code to subtract desired written registers, as well as flagging the cpsr if a negative number is flagged, our result has been stored in register 4 (R4)
	@the "SUBS" operation will correctly set the cpsr flag, but not actually use/handle it.

	@SECTION 4 -> SUBSEQUENTLY STORING THE RESULTS OF THE OPERATIONS BACK INTO THE STACK
	STR R3,[R0],#4 @because our pointer was already incremented back from line 11, we can simply write the contents of register to the updated base-register/pointer, which is R0, and then using post-increment addressing to increment the pointer 4-Bytes more after the data is stored to the stack
	@^^now we have correctly written our addition result to the third entry of our list, directly after integer "b"
	STR R4,[R0],#4 @now we are writing the result of our subtraction operation, which will be directly after our addition result due to our post-increment addressing used, and then we are incrementing once more just in case we want to continue storing data (good practice I guess)

	@now that our arithmetic operation results have been stored subsequently to our stack memory list, we can say that our list will look something like this:
	@ original reference pointer within R0 -> LIST[0]=32, LIST[1]=49, LIST[2]=contents of our addition, LIST[3]=contents of our division


.data @creating data section within the program to store our data list within the stack memory
list: @creating a label for our list in order to allow our registers to refer to a location in the stack memory when carrying out literal addressing
	.word 32,49 @defining the length of each entry within our list in the stack memory, integer "a" = 32, integer "b" = 49
