@ PROGRAM CHALLENGE:
@ - Define a list of 5 integers in memory.
@ - Create a loop that:
@     - Loads each integer one-by-one.
@     - If the integer is greater than 10, add it to a "large_sum" accumulator.
@     - If the integer is less than or equal to 10, add it to a "small_sum" accumulator.
@     - Move to the next entry.
@ - After all integers have been processed, print a "Done!" message to the terminal.

@START CHALLENGE

@r4 will be out large_sum accumulator, r5 will be the small_sum accumulator
.global _start
.section .text
_start:
        LDR R0,=list
        LDR R6,[R0,#20]                 @loading our end list marker to r6, pointer shifted by 20-bytes
        LDR R1,[R0]                     @loading first entry to r1
        MOV R3,#10                      @immediate addressing r3 by moving "10" to do comparison later
loop:
        LDR R1,[R0],#4                  @post-increment addressing, writing to R0 and then increment
        ADD R2,R2,R1                    @adding entry to r2, which we will use for comparison logic
        CMP R2,R6                       @checking if we have reached the end of the list
        BEQ exit                        @if end of list has been reached, then we move to exit label, which will print "done"
        CMP R2,R3                       @if BEQ is ignored, we move to comparing the entry to r3(#10)
        BGT large_sum                   @if the entry is greater, then we move to the "large_sum" label
        BLT small_sum                   @if the entry is smaller, then we move to the "small_sum" label
large_sum:
        ADD R4,R4,R2                    @if entry is greater than 10, we add the entry to r4
        BAL loop                        @once entry has been added, we BAL back to loop: 
small_sum:
        ADD R5,R5,R2                    @if entry is less than 10, we add the entry to r5
        BAL loop                        @once entry has been added, we BAL back to loop:
exit:
        MOV R0,#1                       @syscall for standard output
        LDR R1,=message                 @creating pointer to message
        MOV R2,#5                       @defining message length
        MOV R7,#4                       @syscall to "write"
        SVC #0                          @calling kernel

        MOV R7,#1                       @sycall to terminate program
        SVC #0                          @calling kernel

.section .data                          @defining data section within memory
list:                                   @defining label for our list of integers
        .word 11,9,15,6,20              @creating list of integers, each (32-bit) long
        .word 0xaaaaaaaa                @defining our end of the list entry for comparison logic
message:                                @defining label for our "done" message
        .ascii "Done!"                  @".ascii" to dump raw bytes as they are written, 5-bytes long
