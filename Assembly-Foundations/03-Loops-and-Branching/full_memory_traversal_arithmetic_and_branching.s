@ CHALLENGE:
@ 1. Store two integers into memory (e.g., in a list).
@ 2. Load the integers into registers using indirect addressing.
@ 3. ADD the two integers together and set the CPSR flags.
@ 4. If the addition caused a carry, perform an ADC (add with carry) with a third value (you can make one up).
@ 5. SUBTRACT the original two integers and store the result into the stack.
@ 6. Perform a logical AND between the original two integers and store the result into memory.
@ 7. Perform a logical ORR between the original two integers and store the result into memory.
@ 8. Perform a logical EOR between the original two integers and store the result into memory.
@ 9. Load the subtracted result back from the stack and check if it is negative using the N flag.
@ 10. End the program cleanly (e.g., infinite loop if you want).
@
@ RULES:
@ - Use only MOV, LDR, STR, PUSH, POP, ADD(S), ADC, SUB(S), AND, ORR, EOR.
@ - You may use literal or indirect addressing as needed.
@ - Set CPSR flags carefully with S-suffixed instructions where needed.
@ - You can invent the integers to use.
@ - Do not use division yet.
@ - YOU MUST NOT USE NOTES OR ANY FORM OF HELP, NO IDE, JUST MEMORY
//-------------------------------------------------------------------------------------------------------------------

@BEGIN PROGRAM

.global _start @defining a global reference to our start label
_start: @creating the start label, letting the program know where to begin execution

	@TASK 2 -> Load the integers into registers using indirect addressing.
	LDR R0,=list @using literate addressing to create write a pointer to the first entry within our list in order to locate the subsequent values, this will come in handy when I am trying to manipulate data to and from the stack memory. 
	LDR R1,[R0] @using indirect addressing, we are dereferencing the pointer from our base-register (R0), and then writing the contents of the stack memory address to our register (R1), we have now written integer "a" to register 1! LIST[0]=R1=8
	LDR R2,[R0,#4] @using indirect addressing again, this time with a 4-byte offset in order to traverse to the second entry within the list, or the subsequent stack memory address, and then we write the contents of that address (integer b) to register 2 (R2)! LIST[1]=R2=14
	
	@TASK 3 -> ADD the two integers together and set the CPSR flags.
	ADDS R3,R1,R2 @addition result of register R1(integer a) with register R2(integer b) is carried out, and our cpsr flag is set for any potential carryout, if there is a carryout, then the current program state register will be updated to a "1", else "0"
	@^^ R3=R1+R2

	@TASK 4 -> If the addition caused a carry, perform an ADC (add with carry) with a third value (you can make one up).
	ADC R3,R1,R2 @should there be any carryout, the original sum of our two integers will now be repeated and written to the same register that the "ADDS" did, except this time we will repeat the addition and add the carry that was saved by the previous instruction
	@^^ R3=R1+R2+CARRY , you said I could make my carry value up, so I will say the cpsr saved "1" for the carry, the cpsr will then be updated accordingly.

	@TASK 5 -> SUBTRACT the original two integers and store the result into the stack.
	SUB R4,R1,R2 @using the "SUB" arithmetic operator in order to take the written contents of register R1(integer a) and R2(integer b), I specifically chose this order for the subtraction so that I could showcase what the cpsr will flag when we run a "SUBS" operation later, the difference of the two integers is stored in register 4 (R4)
	STR R4,[R0,#8] @using the "STR" operator to move the data written onto R4 (the result of our subtraction) into the stack, because we are not using any sort of pre/post increment addressing, we need to specifically mention that we are offsetting the data by 12-bytes, in order to place our data from register 4 into the next
	@available stack memory address, while still having it be subsequent to the last entry in our initial list, which is integer b, located at R0 + 4-bytes. So now our result is written into the list -> LIST[2]=R4=R1-R2

	@TASK 6 -> Perform a logical AND between the original two integers and store the result into memory.
	AND R4,R1,R2 @we now perform the logical "AND" operation on the two original integer's "a" and "b", the AND will effectively "filter" the bits, during the individual bit-wise comparison of the binaries, whenever both sides are NOT 1, a 0-bit will be returned, and when both sides ARE 1, a 1-bit will be returned
	@I have chosen to store the result inside of register 4 (R4), as we already wrote the contents of R4 to the stack memory, it is open for use agaim
	STR R4,[R0,#12] @now storing the "AND" result to the subsequent open spot within our list, which is in the stack, which correlates to our pointer at R0 shifted by 12-bytes, once again, this process would be more efficient if I was able to use post-increment addressing, so that I could just dynamically update the pointer as needed, instead of offsetting it each time

	@TASK 7 -> Perform a logical ORR between the original two integers and store the result into memory.
	ORR R4,R1,R2 @we now perform the logical "ORR" operation on the two original integer's "a" and "b", the AND will effectively "combine" the bits, during the individual bit-wise comparison of the binaries, whenever one side is 1, a 1-bit will be returned, and when both sides do not have a 1, (i.e. 0 and 0), a 0-bit will be returned
	@once again using register 4, the AND operation was written to the stack already, so we can use this
	STR R4,[R0,#16] @now storing the "ORR" result to the subsequent open spot within our list, which is in the stack, which correlates to our pointer at R0 shifted by 16-bytes

	@TASK 8 -> Perform a logical EOR between the original two integers and store the result into memory.
	EOR R4,R1,R2 @we now perform the logical "EOR" operation on the two original integer's "a" and "b", during the individual bit-wise comparison of the binaries, whenever the two bits from each side are different, a 1-bit will be returned, and when both sides are the same, (i.e. 0 and 0), a 0-bit will be returned
	@@once again using register 4, the ORR operation was written to the stack already, so we can use this
	STR R4,[R0,#20] @now storing the "EOR" result to the subsequent open spot within our list, which is in the stack, which correlates to our pointer at R0 shifted by 20-bytes

	@TASK 9 -> Load the subtracted result back from the stack and check if it is negative using the N flag.
	LDR R4,[R0,#8] @now loading the subtracted result back from the stack that we placed to R0 + 8-bytes earlier, we are loading it into R4
	MOV R5,#0 @moving a dummy number "0", which will not change anything from our subtracted result into R5, so that I can perform another subtraction using our loaded subtraction result from earlier, except this time using "SUBS" to set cpsr "N" flag
	SUBS R6,R4,R5 @now using the "SUBS" operator to set a cpsr flag in order to check if the result from our stored subtraction result was negative, I am subtracting 0 from the result to not change it.
	@i am sure that there is a better/more effecient way to do this task, but this is all I can think of given that I have no access to notes, IDE, or help

	@TASK 10 -> End the program cleanly (e.g., infinite loop if you want).
	MOV R7,#1 @utilizing immediate addressing to move decimal number "1" into register 7, the special functionality "operating-system" register
	SWI 0 @we then invoke a software interrupt (SWI), in order to call the operating system to come read the contents of register 7, which it then maps to a table of instructions, which then terminates the program, thus ending the program "cleanly" as asked


@TASK 1 -> Store two integers into memory (e.g., in a list).
.data @defining a section within our program, we will allocate this section to hold our list within the stack memory
list: @we have now created a label for our list to be referenced from. When I write a pointer onto my base-register (R0), I will use literal addressing to write the stack memory address to the first entry within the list
	.word 8, 14 
	@defining the length of each entry within the list, this will be held within the stack memory, we are denoting every single entry to be a "word" length, we are using a 32-bit processor
	@so each entry will be 32-bits in length, integer "a" will be the demical number (8), and integer "b" will be the decimal number (14)
