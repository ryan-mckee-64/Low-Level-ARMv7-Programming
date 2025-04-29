@ Tuesday April 29th, 2025
@ MILESTONE CHALLENGE 2:
@ - Store 8 integers in memory.
@ - Set a threshold value (ex: 50) in a register.
@ - Loop through list:
@     - Call function "is_greater_than_threshold":
@         - Input: list entry
@         - Compare to threshold
@         - Output: 1 if greater, 0 if not
@     - If 1, add to large_sum; else, add to small_sum.
@ - After loop:
@     - Compare sums.
@     - Print "Large wins", "Small wins", or "Tie!".
@ - End program cleanly.
@ (BONUS: Save final sums to memory.)

@BEGIN PROGRAM CHALLENGE

.global _start
.section .data
_start:
        MOV R6,#50                              @moving threshhold value to r6 via immediate addressing
        LDR R0,=list                            @reference pointer to memory list
        LDR R5,[R0,#32]                         @loading end list marker to r5 for future CMP logic
loop:                                           @label for loop
        LDR R1,[R0],#4                          @loading data from first entry to r1, then increment by 4-bytes (post-increment addressing)
        CMP R1,R5
        BEQ end_list                            @BEQ for our entry being the end of the list
        PUSH {R1}                               @push r1 to stack to preserve data
        BL is_greater_than_threshhold           @BL to "is_greater_than_threshhold" function
        POP {R1}                                @pop initial r1 data back from stack to get data back
        CMP R2,#1
        BEQ large_sum                           @BEQ to jump to large_sum accumulator if r2 equals 1
        BNE small_sum                           @BNE to jump to small_sum accumulator if r2 does not equal 1
is_greater_than_threshhold:                     @label for threshhold checking function
        CMP R1,R6                               @CMP logic for comparing entry to #50
        ADDGT R2,#1                             @adding #1 to R2 if CMP logic returns entry being more than #50
        ADDLT R2,#0                             @adding #0 to R2 if CMP logic returns entry being less than #50
        BX lr                                   @now that we have stored the value corresponding to the CMP logic, we branch exit to lr address
large_sum:
        ADD R3,R3,R1                            @adding entry to large accumulator, we will use r3
        BAL loop                                @BAL to jump back to loop to start again
small_sum:
        ADD R4,R4,R1                            @adding entry to small accumulator, we will use r4
        BAL loop                                @BAL to jump back to loop to start again
end_list:
        CMP R3,R4                               @CMP logic to determine which accumulator is larger (r3-r4)
        BGT greater_win                         @BGT to branch to greater_win if r3>r4
        BLT smaller_win                         @BLT to branch to smaller_win if r3<r4
        BEQ balance_win                         @BEQ to branch to balance_win if r3=r3, there is a tie
greater_win:
        MOV R0,#1                               @syscall for stdout
        LDR R1,=lmessage                        @reference pointer to lmessage label
        MOV R2,#10                              @message length
        MOV R7,#4                               @syscall for write
        SVC #0                                  @kernel

        MOV R7,#1                               @syscall for terminate program
        SVC #0                                  @calling kernel
smaller_win:
        MOV R0,#1                               @syscall for stdout
        LDR R1,=smessage                        @reference pointer to smessage label
        MOV R2,#10                              @message length
        MOV R7,#4                               @syscall for write
        SVC #0                                  @kernel

        MOV R7,#1                               @syscall for terminate program
        SVC #0                                  @calling kernel
balance_win:
        MOV R0,#1                               @syscall for stdout
        LDR R1,=tmessage                        @reference pointer to tmessage label
        MOV R2,#4                               @message length
        MOV R7,#4                               @syscall for write
        SVC #0                                  @kernel

        MOV R7,#1                               @syscall for terminate program
        SVC #0                                  @calling kernel

.section .data
list:                                           @list label for referencing
        .word 126,50,12,8,70,30,14,94           @defining list of 8-integers, all with 32-bit length
        .word 0xaaaaaaaa                        @defining end list marker
lmessage:                                       @larger message label for referencing
        .ascii "Large wins"                     @".ascii" to dump raw bytes as types, 10-bytes
smessage:                                       @smaller  message label for referencing
        .ascii "Small wins"                     @".ascii" to dump raw bytes as types, 10-bytes
tmessage:                                       @tie message label for referencing
        .ascii "Tie!"                           @".ascii" to dump raw bytes as types, 4-bytes
