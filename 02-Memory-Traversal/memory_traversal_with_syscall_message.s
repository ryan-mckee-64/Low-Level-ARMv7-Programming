@ PROGRAM CHALLENGE:
@ - Print a welcome message to the terminal.
@ - Store two integers on the stack, and load them back into registers.
@ - Compare the two integers and branch to a label depending on their relationship (greater, less, or equal).
@ - Inside each branch, perform arithmetic (MUL) and logical operations (AND, ORR, EOR).
@ - Apply logical shifts (LSL) and rotates (ROR) on your results.
@ - After completing the branch operations, print a "complete" message to the terminal.

.global _start                          @global ref to start label
.section .text                          @allocate memory for text section
_start:                                 @deifning start label for execution

@1->printing welcome message to terminal

        MOV R0,#1                       @syscall for standard output
        LDR R1,=welcome                 @creating reference pointer to welcome message
        MOV R2,#13                      @defining welcome message length, 13-bytes
        MOV R7,#4                       @syscall for "write" to terminal
        SVC #0                          @calling kernel via supervisor call

@2->storing two integers to the stack, and loading them back into registers

        MOV R1,#0xFF                    @immediate addressing r1 with #4, integer a
        MOV R2,#0xFA                    @immediate addressing r2 with #6, integer b
        PUSH {R1,R2}                    @pushing registers r1/r2 to the stack, sp->-8-bytes
        MVN R1,R1                       @negating what is currently in r1, then moving back to r1
        AND R1,R1,#0xFF                 @AND R1 with #0xFF, filtering the bits, rewriting register to 0
        MVN R2,R2                       @negating what is currently in r2, then moving back to r2
        AND R2,R2,#0xFA                 @AND R2 with 0xFA, filtering the bits, rewriting register back to 0
        POP {R1,R2}                     @POP data from stack back into r1/r2

@3->compare the two integers and branch to a label depending on their relationship (greater,less, or equal)

        CMP R1,R2                       @using comparator check the difference of data within r0/r1 (r0-r1)

        BGT greater                     @creating "branch greater than" (BGT) to reference "greater" label
        BLT lesser                      @creating "branch lesser than" (BLT) to reference "lesser" label
        BAL equal                       @creating "branch always" (BAL) to reference the default/equal label

@4->inside each branch, perform arithmetic (MUL) and logical operations (AND,ORR,EOR)
@5->apply logical shifts (LSL) and rotates on your results
@6->after completing the branch operations, print a "complete" message to the terminal

greater:
        MUL R3,R1,R2                    @performing multiplication on r1/r2, and storing result in r3
        AND R4,R1,R2                    @performing AND on r1/r2, storing in r4
        ORR R5,R1,R2                    @performing ORR on r1/r2, storing in r5
        EOR R6,R1,R2                    @performing EOR on r1/r2, storing in r6

        MOV R4,R4,LSL #1                @moving result from r4->r4 and performing LSL for n=1, storing back to r4
        MOV R5,R5,LSR #1                @moving result from r5->r5 and performing LSR for n=1. storing back to r5
        ROR R6,#1                       @performing logical rotation (ROR) on data in r6 for n=1. gonna be large number

@->printing completion message

        MOV R0,#1                       @syscall for standard output
        LDR R1,=complete                @creating reference pointer to complete message
        MOV R2,#8                       @defining message length, 8-bytes
        MOV R7,#4                       @syscall for write to terminal
        SVC #0                          @calling kernel

        MOV R7,#1                       @syscall for termination of program
        SVC #0                          @calling kernel to terminate, making sure to terminate program so that we are not continuing onto other labels

lesser:
         MUL R3,R1,R2                    @performing multiplication on r1/r2, and storing result in r3
        AND R4,R1,R2                    @performing AND on r1/r2, storing in r4
        ORR R5,R1,R2                    @performing ORR on r1/r2, storing in r5
        EOR R6,R1,R2                    @performing EOR on r1/r2, storing in r6

        MOV R4,R4,LSL #1                @moving result from r4->r4 and performing LSL for n=1, storing back to r4
        MOV R5,R5,LSR #1                @moving result from r5->r5 and performing LSR for n=1. storing back to r5
        ROR R6,#1                       @performing logical rotation (ROR) on data in r6 for n=1. gonna be large number

@->printing completion message

        MOV R0,#1                       @syscall for standard output
        LDR R1,=complete                @creating reference pointer to complete message
        MOV R2,#8                       @defining message length, 8-bytes
        MOV R7,#4                       @syscall for write to terminal
        SVC #0                          @calling kernel

equal:
        MUL R3,R1,R2                    @performing multiplication on r1/r2, and storing result in r3
        AND R4,R1,R2                    @performing AND on r1/r2, storing in r4
        ORR R5,R1,R2                    @performing ORR on r1/r2, storing in r5
        EOR R6,R1,R2                    @performing EOR on r1/r2, storing in r6

        MOV R4,R4,LSL #1                @moving result from r4->r4 and performing LSL for n=1, storing back to r4
        MOV R5,R5,LSR #1                @moving result from r5->r5 and performing LSR for n=1. storing back to r5
        ROR R6,#1                       @performing logical rotation (ROR) on data in r6 for n=1. gonna be large number

@->printing completion message

        MOV R0,#1                       @syscall for standard output
        LDR R1,=complete                @creating reference pointer to complete message
        MOV R2,#8                       @defining message length, 8-bytes
        MOV R7,#4                       @syscall for write to terminal
        SVC #0                          @calling kernel to terminate program

        MOV R7,#1                       @syscall for termination of program
        SVC #0                          @calling kernel to terminate



.section .data                          @creating data section to house message labels
welcome:                                @defining welcome label to reference message
        .ascii "Welcome User!"          @".ascii" to dump raw bytes as typed, 13-bytes long
complete:                               @defining complete label to reference message
        .ascii "Complete"               @".ascii" to dump raw bytes as typed, 8-bytes long
