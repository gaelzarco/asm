## Registers

Inside all CPUs exist #registers
  - They are variables that are used as memory for your computer.
  - They are the width of the instruction set.
    - A 64-bit computer has registers that are 64 bits wide.
  - Each register has a different name
    - `rdi`
    - `rsi`
    - `r8`

__The following instructions are written for x86 and x86-64 CPU architecutre__

You may perform operations in and out of registers using the following operations:
```assembly
mov rdi, 8
// Move the constant value of 8 into the rdi register

mov rdi, rsi 
// Move the the value in rsi to the rsi register
```

You may also perform memory operations:
```assembly
mov rdi, qwordptr[rsi]
// Treat the value of rsi as a pointer and remove the quadword length (using the code snippet above, the length would be 8-bytes, or 64 bits) from memory and put in into rdi.

// The same operation can be applied in reverse
mov qwordptr[rsi], rdi
```

In the above example of memory operations, we first performed a load operation because we took values from memory and placed them into registers. Then, we tooks values that were in registers and placed them back into memory which is known as a store operation.
  

## Programming Assembly

[Follow Along](./assem.s)

Before you begin you must specify some boilerplate to tell the assembler what to do.

```assembly
.global _start
// Exposes symbol called start to the linker so that it knows where our code starts

.intel_syntax noprefix
// Makes code easier to read and write for human beings

// This defines the beginning of our program
_start:
// ...
```

__Here is the ARM CPU architecture equivalent__
```assembly
.global _start

_start:
```

This code is now ready to assemble. Ensure that you have the dependency `gcc` installed on you machine in order to utilize `as` to compile the program

```bash
// x86
as assem.s -o assem.o

// ARM
as -arch arm64 -o assem.o assem.s
```

This is still not an executable so we need to envoke the linker to make it a full _elf_ that runs.

In its current state, it is merely an intermediate object.

```bash
// x86
// Links object file into an executable
gcc -o assem assem.o -nostdlib -static

// ARM
// Links object file into an executable
gcc -o assem assem.o -nostdlib -static -arch arm64

// Mac
// This uses the MacOS linker and specifies the program entrypoint
ld -o assem assem.o -e _start -arch arm64
```
__-nostdlib__: Tells the linker not to use the standard libraries (e.g., libc). This is often used in low-level programming or when you provide your own startup code and runtime.

__-static__: Links the executable statically, meaning all libraries will be included in the executable itself, with no dynamic linking at runtime.

The flags above allow us the assembler to compile the code more predictably.

_To check if your system is x86 or ARM, you can run the `arch` command on Unix operating systems_

```bash
arch
```

Here is another line of machine code:

```assembly
// ...
// Operation code (opcode): add
// Three Operands: x1, x0, #1
add x1, x0, #1
```

Opcode dictates what instruction does and operands specify which values are used.

In the example above: 
- The instruction adds 1 to the value in the x0 register 
- Places the result in the x1 register.

The assembler then converts the code above to:

```binary
// ARM
10010001000000000000010000000001
```

[ARM64 Instruction Set: _Add_](https://developer.arm.com/documentation/ddi0602/latest/Base-Instructions/ADD--immediate---Add--immediate--) this can be broken down into its components:
1001000100     <- Operation code for the add instruction
000000000001   <- immediate value to add, #1
00000          <- source register, x0
00001          <- destination register, x1


## Assembly Interoperability with C 

Assembly can be run in a C program. Here is an example Assembly function:

```assembly
.global fn 
.type fn, "function"
.p2align 4

fn: 
    add x0, x0, x1 
    ret

```
_gcc requires the end of the file to be a blank line, so make sure to include the last blank line in your code_

Here is the Apple silicon equivalent:
```assembly
.global _fn
.p2align 2

_fn:
    add x0, x0, x1 
    ret
```

- `.global` directive marks the `fn` function as a global symbol which enables us to reference it in our C code.
- `.type` directive is self-explanatory.
- `.p2align` directive ensures that our code is properly aligned in memory to an 8-byte boundary (64-bit).
- Adds the values of `x1` and `x0` and stores it back into `x0`
    - `x0` and `x1` are the first two arguments in a function and `x0` is used for the return value

Here is the C code to demonstrate the interoperability:
```c
#include <stdio.h>

// No need to prefix fn as _fn if on Apple silicon
extern int fn(int a, int b);

int main() {
    int a = 4;
    int b = 5;
    
    printf("Calling assembly function fn with x0=%d and x1=%d results in %d\n", a, b, fn(a,b));

    return(0);
}
```

- `extern` keyword tells the compiler to look outside of the program.
    - In this case, it find our asm code, saved in a separate file, and runs it whenever we call the `fn` command.
    - The asm and C code can exist in separate folders but the path needs to be defined when building the program.

Here is our example file structure:
/
|-- asm_c
|   |-- asm.c
|
|-- asm_s
    |-- asm.s
_The files should exist in an `src` folder, however I decided to do this dumb ass folder structure._

Building:
```bash
gcc -g -o out_a64 asm_c/asm.c asm_s/asm.s
```

Running:
```bash
./out_64
```

Output:
`Calling assembly function fn with x0=4 and x1=5 results in 9`

#### This is a simple introduction into programming with assembly. This guide will flesh itself out as I find the time to write more notes and get my feet wet. 
