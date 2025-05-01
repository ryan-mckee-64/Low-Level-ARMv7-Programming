.global _start                         @creating global symbol for entry point "_start"
.section .text                         @defining the code section for program instructions
_start:                                @entry point label for program execution
    MOV     R4, #0                     @initialize attempt counter register r4 to zero

welcome_message:                       @label to display "enter pin" prompt
    MOV     R0, #1                     @set r0 to stdout file descriptor
    LDR     R1, =entry_message         @load address of "enter pin" prompt into r1
    MOV     R2, #11                    @define length of message (11 bytes)
    MOV     R7, #4                     @syscall number for write (linux)
    SVC     #0                         @trigger kernel to print message to terminal

get_input:                             @label to read user input
    MOV     R0, #0                     @set r0 to stdin file descriptor
    LDR     R1, =user_input            @load address of input buffer into r1
    MOV     R2, #5                     @read 5 bytes (4 digits + newline)
    MOV     R7, #3                     @syscall number for read (linux)
    SVC     #0                         @trigger kernel to read input
    BL      check_passcode            @branch to "check_passcode" and store return address in lr

correct_passcode:                      @label for successful pin entry
    MOV     R0, #1                     @set r0 to stdout
    LDR     R1, =access_granted        @load address of "access granted" message
    MOV     R2, #14                    @message length = 14 bytes
    MOV     R7, #4                     @syscall number for write
    SVC     #0                         @print message to terminal
    MOV     R7, #1                     @syscall number for exit
    SVC     #0                         @terminate program

wrong_passcode_2:                      @label for 1st incorrect attempt
    MOV     R0, #1                     @set r0 to stdout
    LDR     R1, =wrong_code_2          @load address of "two attempts left" message
    MOV     R2, #30                    @message length = 30 bytes
    MOV     R7, #4                     @syscall number for write
    SVC     #0                         @print message to terminal
    BL      welcome_message            @branch to display "enter pin" prompt again
    B       get_input                  @branch to read input again

wrong_passcode_1:                      @label for 2nd incorrect attempt
    MOV     R0, #1                     @set r0 to stdout
    LDR     R1, =wrong_code_1          @load address of "one attempt left" message
    MOV     R2, #29                    @message length = 29 bytes
    MOV     R7, #4                     @syscall number for write
    SVC     #0                         @print message to terminal
    BL      welcome_message            @branch to display "enter pin" prompt again
    B       get_input                  @branch to read input again

locked_out_label:                      @label for 3rd failed attempt
    MOV     R0, #1                     @set r0 to stdout
    LDR     R1, =locked_out            @load address of "locked out" message
    MOV     R2, #11                    @message length = 11 bytes
    MOV     R7, #4                     @syscall number for write
    SVC     #0                         @print message to terminal
    MOV     R7, #1                     @syscall number for exit
    SVC     #0                         @terminate program

check_passcode:                        @function to validate user input
    MOV     R5, #0                     @reset index counter r5 to 0
    MOV     R6, #0                     @reset mismatch flag r6 to 0
    LDR     R1, =user_input            @load input buffer address into r1
    LDR     R2, =correctdig            @load correct digit address into r2

passcode_loop:                         @loop to check each digit
    LDRB    R0, [R1, R5]               @load byte r0 from user_input[r5]
    SUB     R0, R0, #'0'               @convert ascii to integer (ascii '0' → int 0)
    LDRB    R3, [R2, R5]               @load correct digit r3 from correctdig[r5]
    CMP     R0, R3                     @compare user input to correct digit
    BNE     set_mismatch               @branch to set_mismatch if digits do not match
    ADD     R5, R5, #1                 @increment index counter
    CMP     R5, #4                     @check if 4 digits have been compared
    BNE     passcode_loop              @if not, loop back to check next digit
    CMP     R6, #0                     @check if any mismatch occurred
    BEQ     correct_passcode           @if no mismatch, branch to success label
    ADD     R4, R4, #1                 @else, increment attempt counter
    BL      check_r4                   @branch to handle failed attempt case
    BX      LR                         @return from function

set_mismatch:                          @handles when a digit does not match
    MOV     R6, #1                     @set mismatch flag to 1
    ADD     R5, R5, #1                 @increment index to continue checking all digits
    CMP     R5, #4                     @check if we reached end of pin
    BNE     passcode_loop              @continue looping if not done
    CMP     R6, #0                     @re-check mismatch flag
    BEQ     correct_passcode           @if somehow no mismatch, branch to success
    ADD     R4, R4, #1                 @increment attempt counter
    BL      check_r4                   @handle next failure case
    BX      LR                         @return from function

check_r4:                              @determines which failure message to display
    CMP     R4, #1                     @compare attempt count to 1
    BEQ     wrong_passcode_2           @if 1st fail, branch to two attempts left
    CMP     R4, #2                     @compare attempt count to 2
    BEQ     wrong_passcode_1           @if 2nd fail, branch to one attempt left
    CMP     R4, #3                     @compare attempt count to 3
    BEQ     locked_out_label           @if 3rd fail, branch to locked out
    BX      LR                         @return from function if none match

.section .data                         @section for static data storage
correctdig:                            @label for stored correct pin
    .byte   4,2,1,9                    @stored passcode "4219" as bytes
    .word   0xaaaaaaaa                 @end marker or dummy padding

access_granted:                        @success message
    .ascii  "Access Granted\n"         @14-byte string including newline

wrong_code_1:                          @failure message (one attempt left)
    .ascii  "Wrong Code, One Attempt Left\n"   @29-byte string

wrong_code_2:                          @failure message (two attempts left)
    .ascii  "Wrong Code, Two Attempts Left\n"  @30-byte string

locked_out:                            @locked out message after 3 failures
    .ascii  "LOCKED OUT\n"             @11-byte string

entry_message:                         @prompt for entering pin
    .ascii  "Enter PIN:\n"             @11-byte string

.section .bss                          @bss section for uninitialized data
user_input:                            @buffer to store user input
    .space  5                          @allocate 5 bytes for 4 digits + newline
