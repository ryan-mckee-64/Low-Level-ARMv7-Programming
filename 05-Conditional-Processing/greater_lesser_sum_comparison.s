@ PROGRAM CHALLENGE:
@ - Define a list of 6 integers in memory (some greater than 15, some less than or equal to 15).
@ - Initialize two accumulators:
@     - "greater_sum" for numbers greater than 15
@     - "lesser_sum" for numbers less than or equal to 15
@ - Create a loop that:
@     - Loads each number one-by-one from the list.
@     - Checks if the number is the end marker (0xAAAAAAAA). If so, exit the loop.
@     - Otherwise:
@         - If number > 15, add to greater_sum.
@         - If number <= 15, add to lesser_sum.
@ - After the loop ends:
@     - Compare greater_sum and lesser_sum.
@     - If greater_sum is larger, print "Greater Wins!".
@     - If lesser_sum is larger, print "Lesser Wins!".
@     - If they are equal, print "Tie!".
@ - Cleanly terminate the program.

global _start 
.section .text
_start:
        LDR R0,=list
        LDR R6,[R0,#24]         @loading end list marker to R6 for CMP logic
        MOV R2,#15              @immediate addressing r2, loading 15 for future CMP logic
loop:
        LDR R1,[R0],#4          @loads the number to r1, then increments by 4-bytes (post-increment addressing)
        CMP R1,R6               @compares entry to end-list marker
        BEQ end_loop            @if entry is equal to last entry marker, jump to exit label
        CMP R1,R2               @comparing entry in r1 to #15 in r2

        BGT greater_sum
        BLE lesser_sum

greater_sum:                    @defining a label for if comparator returns greater than 15
        ADD R4,R4,R1            @adding entry stored in r1 to greater than 15 accumulator, accumulator is r4
        BAL loop                @using BAL to by default return to the loop to continue list iteration

lesser_sum:
        ADD R5,R4,R1            @adding entry stored in r1 to lesser/equal than 15  accumulator, accumulator is r5
        BAL loop                @using BAL to by default return to the loop to continue list iteration

end_loop:
        CMP R4,R5               @comparing the greater/lesser accumulators (r4/r5)

        BGT greater_message     @creating branch for if the greater accumulator is larger (r4>r5)
        BLT lesser_message      @creating branch for if the lesser accumulator is smaller (r4<r5)
        BEQ tie_message         @creating branch for if the two are equal (r4=r5)

greater_message:
        MOV R0,#1               @syscall for standard output
        LDR R1,=gmessage        @pointer to gmessage label
        MOV R2,#13              @defining message length
        MOV R7,#4               @syscall for writing to terminal
        SVC #0                  @calling kernel

        MOV R7,#1               @syscall for termination
        SVC #0                  @calling kernel for termination

lesser_message:
        MOV R0,#1               @syscall for standard output
        LDR R1,=lmessage        @pointer to gmessage label
        MOV R2,#12              @defining message length
        MOV R7,#4               @syscall for writing to terminal
        SVC #0                  @calling kernel

        MOV R7,#1               @syscall for termination
        SVC #0                  @calling kernel for termination

tie_message:
        MOV R0,#1               @syscall for standard output
        LDR R1,=tmessage        @pointer to gmessage label
        MOV R2,#4              @defining message length
        MOV R7,#4               @syscall for writing to terminal
        SVC #0                  @calling kernel

        MOV R7,#1               @syscall for termination
        SVC #0                  @calling kernel for termination
.section .data
list:
        .word 28,16,15,13,5,15  @defining list of 6 integers
        .word 0xaaaaaaaa        @defining end list marker
gmessage:
        .ascii "Greater Wins!"  @13-bytes
lmessage:
        .ascii "Lesser Wins!"   @12-bytes
tmessage:
        .ascii "Tie!"           @4-bytes
dmessage:
        .ascii "Exit Loop"      @9-bytes
