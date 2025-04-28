@ PROGRAM CHALLENGE:
@ - Create a program that defines a list of five integers in memory.
@ - Load the first value of the list into a register to initialize an "accumulator."
@ - Create a loop that:
@     - Loads the next value from the list.
@     - Adds it to the accumulator.
@     - Moves to the next entry in the list.
@ - When all values have been added (after fifth value), exit the loop.
@ - After the loop ends, print a "Complete" message to the terminal.

.global _start                  @global reference to _start:
.equ endlist, 0xaaaaaaaa        @defining constant that is end of the list (open memory slot)
.section .text                  @defining text section
_start:                         @defining start label for program execution
        LDR R0,=list            @reference pointer to beginning of list
        LDR R3,=endlist         @loading our endlist reference into r3
        LDR R1,[R0]             @initial element loaded to r1
        ADD R2,R2,R1            @adding first entry to r2, our accumulator
loop:                           @defining label for loop
        LDR R1,[R0,#4]!         @increments to second entry in the list, and then writes data to r1
        CMP R1,R3               @compares the contents of r1/r3, checking if we are at the end of the list
        BEQ exit                @BEQ "branch equal to" used to determine whether we continue with the loop, or skip to exit label
        ADD R2,R2,R1            @if BEQ op is ignored, we add our entry to R2  
        BAL loop                @then we repeat the loop by using a BAL (branch always)

exit:
        MOV R0,#1               @syscall for standard output
        LDR R1,=message         @creating pointer to "complete" message
        MOV R2,#7               @defining message length (7-bytes)
        MOV R7,#4               @syscall for "Write" to terminal
        SVC #0                  @calling kernel to write

        MOV R7,#1               @syscall for termination of program
        SVC #0                  @calling kernel to terminate

.section .data
list:
        .word 1,2,3,4,5         @defining list of integers, each with 32-bit length
message:
        .ascii "Complete"       @.ascii to dump ray bytes as typed, 7-byte length

@program stores a list of 5 integers, loads the first element to a register, then adds that initial element to another register
@we have defined a constant via ".equ" that holds the value "0xaaaaaaaa", which holds the same value as an empty memory location
@a loop was then implemented, first, we iterate by 4-bytes to the next list element, and then write the data to r1, this is done via pre-increment addressing
@the data in r1 is then checked against the constant "0xaaaaaaaa" using the comparator operator (CMP) to see if we have reached the end of the list
@if we have, then we take the BEQ (branch equal to) route, which writes a completion message to the terminal, and terminates the program
@if the comparator returns as "not equal to", then we add the result back to our accumulator register (r2), and then uses a BAL to loop back to the top
@of our "loop:" label
