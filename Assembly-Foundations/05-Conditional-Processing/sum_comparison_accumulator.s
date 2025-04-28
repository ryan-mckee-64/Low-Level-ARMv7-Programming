@ Monday April 28th, 2025
@ CHALLENGE:
@ - Store 8 integers in memory (mix small/large).
@ - Initialize two sums: small_sum (<=20), large_sum (>20).
@ - Loop through list:
@     - Load each integer.
@     - If >20, add to large_sum.
@     - Else, add to small_sum.
@ - After loop:
@     - Compare sums.
@     - Print "Small wins", "Large wins", or "Tie!".
@ - End program cleanly (optional infinite loop).

@BEGIN CHALLENGE

.global _start                          @defining global reference to _start:
.section .text                          @creating text section for code
_start:                                 @creating _start: label for execution
        LDR R0,=list
        MOV R6,#20                      @moving #20 into r6 to use for CMP logic later on
        LDR R5,[R0,#32]                 @loading end list marker to r5 for CMP logic later on
loop:
        LDR R1,[R0],#4                  @loading first entry into r1, then incrementing by 4-bytes, via post-increment addressing
        CMP R1,R5                       @performing comparison logic for checking endlist value
        BEQ comp_results                @if entry equal to end list marker, jump to exit_loop label to leave the loop
        CMP R1,R6                       @CMP to evaluate result between list entry and r6(#20)
        BLE small_sum                   @BLE (branch less than) to send program to small_sum label
        BGT large_sum                   @BGT (branch greater than) to send program to large_sum label

small_sum:
        ADD R3,R3,R1                    @add the entry to register 3, "lesser accumulator"
        BAL loop                        @BAL to send program back to the loop by default

large_sum:
        ADD R4,R4,R1                    @add entry to resigert 4, "greater accumulator"
        BAL loop                        @BAL to send program back to the loop by default

comp_results:
        CMP R3,R4                       @CMP to compare the results of each accumulation of sums
        BGT winner_small                @branch to label if (r3>r4)
        BLT winner_great                @branch to label if (r3<r4)
        BEQ winner_tie                  @branch to label if (r3=r4)

winner_small:
        MOV R0,#1                       @syscall for standard output
        LDR R1,=smessage                @pointer to smaller win message
        MOV R2,#10                      @define message length
        MOV R7,#4                       @syscall for "write" to terminal
        SVC #0                          @calling kernel

        MOV R7,#1                       @syscall to terminate
        SVC #0                          @calling kernel

winner_great:
        MOV R0,#1                       @syscall for standard output
        LDR R1,=lmessage                @pointer to smaller win message
        MOV R2,#10                      @define message length
        MOV R7,#4                       @syscall for "write" to terminal
        SVC #0                          @calling kernel

        MOV R7,#1                       @syscall to terminate
        SVC #0                          @calling kernel

winner_tie:
        MOV R0,#1                       @syscall for standard output
        LDR R1,=tmessage                @pointer to smaller win message
        MOV R2,#4                       @define message length
        MOV R7,#4                       @syscall for "write" to terminal
        SVC #0                          @calling kernel

        MOV R7,#1                       @syscall to terminate
        SVC #0                          @calling kernel



.section .data                          @creating a section in memory for our data
list:                                   @defining a label for the list, for referencing to a register
        .word 15,80,30,7,9,50,100,12    @storing 8 integers to memory, each with a length of 32-bytes
        .word 0xaaaaaaaa                @defining end of list marker
smessage:
        .ascii "Small Wins"             @using ".ascii" to dump raw bytes as typed, 10-bytes
lmessage:
        .ascii "Large Wins"             @using ".ascii" to dump raw bytes as typed, 10-bytes
tmessage:
        .ascii "Tie!"                   @using ".ascii" to dump raw bytes as typed, 4-bytes
