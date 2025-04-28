# ARMv7 Assembly Projects

This repository contains a collection of ARMv7-A assembly language programs focused on low-level system programming concepts. Projects include memory traversal, conditional branching, accumulator management, syscall interface handling, and clean control flow design.

All programs are manually written without the use of an IDE, assembled and linked using direct terminal workflows inside a Linux environment.

---

## Folder Structure

- `01-Basic-Operations/` — Basic MOV, ADD, CMP operations and simple branching.
- `02-Memory-Traversal/` — Loading values from memory lists and pointer walking.
- `03-Loops-and-Branching/` — Looping through memory, conditionally processing values.
- `04-Accumulator-Programs/` — Programs managing multiple accumulators (e.g., large_sum, small_sum).
- `05-Conditional-Processing/` — Advanced branching based on value comparison logic.
- `06-Terminal-Syscalls/` — Writing messages to the terminal using Linux syscalls.
- `07-Mini-Mastery-Challenges/` — Complete projects combining memory traversal, conditionals, accumulators, and syscalls.

---

## Technologies Used

- **Architecture:** ARMv7-A (32-bit ARM architecture)
- **Assembler:** GNU `as` (GNU assembler)
- **Linker:** GNU `ld`
- **Environment:** Linux (Ubuntu-based VM)
- **Development Style:** Manual terminal-based assembly and linking, no IDEs used.

---

## What I've Practiced

- Manual memory traversal
- Looping with conditional branches (BGT, BLE, BEQ)
- Safe accumulator and register management
- Terminal output via direct syscalls
- Clean control flow design and program termination

---

## Future Plans

- Expand into more complex subroutine management (BL, BX LR)
- Implement nested loops and multi-level branching
- Create basic file I/O handlers using Linux syscalls
- Start exploring shellcode writing and reverse engineering exercises

---

## Disclaimer

These projects are part of a personal low-level systems programming learning journey, starting from basic assembly principles and advancing toward real-world embedded systems and reverse engineering concepts.
