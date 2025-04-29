@Monday April 28th, 2025
@Written with no IDE, no help, no notes, after 5 days of learning ARMv7->assembly
@ MILESTONE CHALLENGE:
@ - Create a list of 10 integers (mix small/large).
@ - Loop through list:
@     - Call function "is_greater_than_50" with each entry.
@     - If >50, add to large_sum; else add to small_sum.
@ - Function:
@     - Input: number in R0.
@     - Output: 1 (greater) or 0 (not greater) in R0.
@ - After loop:
@     - Compare sums.
@     - Print "Large numbers dominate", "Small numbers dominate", or "Balance achieved."
@ - End program cleanly (infinite loop or syscall exit).
@ (BONUS: STR final sums to memory.)

@BEGIN CHALLENGE

.global _start                                  @defining global reference to start label
.section .text                                  @creating section for program code
_start:                                         @defining start label to begin program execution
        LDR R0,=list                            @reference pointer to list
        MOV R6,#50                              @moving 50 into r6 for CMD logic later on
        LDR R5,[R0,#40]                         @loading end marker to r5 for CMP logic
loop:                                           @loop label
        LDR R1,[R0],#4                          @loading entry from list, then interating by 4-bytes
        CMP R1,R5                               @CMP logic to see if we are at the end of the list
        BEQ exit                                @branch to exit if end of list is reached
        PUSH {R0}                               @pushing r0 to stack to preserve initial value of r0 before function call, sp->-4-bytes
        BL is_greater_than_50                   @BL (branch link) to our is_greater_than_50 function
        POP {R0}                                @popping r0 back from stack to get data back after function call
        CMP R1,R6                               @CMP logic to compare entry in r0 to #50 in r6
        BGT large_sum                           @BGT to large_sum if r1>r6
        BLE small_sum                           @BLE to small_sum if r1<=r6

is_greater_than_50:
        CMP R0,R6                               @CMP to compare R0 to R6 to see if greater or less
        MOVGT R0,#1                             @using conditional intruction execution to move appropriate value to r0, either 0 or 1 based on CMP result
        MOVLT R0,#0                             @using conditional intruction execution to move appropriate value to r0, either 0 or 1 based on CMP result
        BX lr                                   @branch exit back to link register address, where we can pop the original value of r0 before function call from stack

large_sum:                                      @large_sum label definition
        ADD R2,R2,R0                            @ADD our entry from r0 into r2, r2 will be our small sum accumulator 
        BAL loop                                @BAL back to the beginning of the loop to repeat process

small_sum:                                      @small_sum label definition
        ADD R3,R3,R0                            @ADD our entry from r0 into r3, r3 will be our small sum accumulator
        BAL loop                                @BAL back to the beginning of the loop to repear the process

exit:                                           @label for exit, when we reach the end of the list, we will compare the results here and print the message appropriately
        CMP R2,R3
        BGT bigger_winner                       @CMP logic for branching to a label where the bigger sum is the winner!
        BLT smaller_winner                      @CMP logic for branching to a label where the smaller sum is the winner!
        BEQ balance_winner                      @CMP logic for branching to a label where the sums are equal to each other!

bigger_winner:
        MOV R0,#1                               @syscall for stdout
        LDR R1,=largemessage                    @pointer to message
        MOV R2,#22                              @message length
        MOV R7,#4                               @syscall for write
        SVC #0                                  @calling kernel

        MOV R7,#1                               @syscall for terminate
        SVC #0                                  @calling kernel

smaller_winner:
        MOV R0,#1                               @syscall for stdout
        LDR R1,=smallmessage                    @pointer to message
        MOV R2,#22                              @message length
        MOV R7,#4                               @syscall for write
        SVC #0                                  @calling kernel

        MOV R7,#1                               @syscall for terminate
        SVC #0                                  @calling kernel

balance_winner:
        MOV R0,#1                               @syscall for stdout
        LDR R1,=equalmessage                    @pointer to message
        MOV R2,#16                              @message length
        MOV R7,#4                               @syscall for write

        MOV R7,#1                               @syscall for terminate
        SVC #0                                  @calling kernel


.section .data                                  @creating section for data
list:                                           @defining list label for referencing
        .word 3,127,96,12,32,432,56,5,15,100    @defining list, each 32-bits long
        .word 0xaaaaaaaa                        @defining end list marker for CMP logic
largemessage:                                   @label for "larger" message
        .ascii "Large numbers dominate"         @".ascii" to dump raw bytes as typed, 22-bytes
smallmessage:                                   @label for "smaller"  message
        .ascii "Small numbers dominate"         @".ascii" to dump raw bytes as typed, 22-bytes
equalmessage:                                   @label for "equal" message
        .ascii "Balance achieved"               @".ascii" to dump raw bytes as typed, 16-bytes
