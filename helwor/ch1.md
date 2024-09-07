# Arm Assembly

There are essentially three mnemonics or opcodes.

- Rd = destination
- Rn = source
- op2 = register or an immediate

__Registers__: `r0` - `r15`

Immediate values are how you write values that are not calculated
- Limited to values between 0 - 255 (unsigned)
- Entered using `#` followed by char surrounded by single quotes `'f'`
    - OR a number in binary, octal, decimal, or hexadecimal. 

Limited so designers added barrel shifter into CPU to shift base range

All of these values would be possible:

    0x000000FF: 255, no shift
    0x00FF0000: 255, left shift 16 for a value of 16,711,680
    0x000FF000: 255, left shift 12 for a value of 1,044,480

These would NOT be possible:

    0x00234500: Rotated value (0x2345) too large
    0x000007F8: Rotated value (0xFF) rotated an odd number of places
    0x000001FF: Base value too large

Larger numbers are "fixed" by compiler by loading into memory and then loading it into the register when needed.
- This takes an extra second or two
- Results in 1/500,000 of a second on performance

## Writing Code

Every function requires a `_start` function
- Not actually a function, but a label

Two sections of code required:
- `.text`
    - Tells compiler where the operations live
    - Anything written here will never change during program execution
    - Usually omitted, compiler assumes its existence
- `.data`
    - Loads values that cannot be entered as immediate values
    - Reserves space for our program to use during execution
- `.global`
    - Exposes labels from code to compiler and linker

### Exiting

If you do not exit the program, the computer will keep reading data in memory past the last opcode.
- Leads to segmentation fault as it will drift into memory that you do not have access to.

### Mov
#mov

__Moves a value to a register__
- Can be an immediate value or a value stored in a different register

```assembly
    mov     r0, #2          @ moves the value 2 into register 0 
    mov     r1, r0          @ copies the value 2 from register 0 to register 1 
                            @ register 0 is still equal to 2
```

### Supervisor Calls 
#syscalls

__How programs communicate with the operating system__

There are two ways to do this in ARM assembly. We will only be using one format:

    Supervisor call number loaded into r7 (without the 0x900000 prefix)
    Parameters generally loaded into r0-r3
    Supervisor call executed with the command `svc 0`

[syscall table](https://syscalls.w3challs.com/?arch=arm_strong)

The syscall tables above is read by:
- Noticing the command name on the left
- Reading the value that is passed into the r7 register (without the prefix: 0x900000)
- The next few columns are parameters that will be passed into the function
    - Labeled `r0` - `r5`

For the exit command, only one value needs to be passed in which is of `error_code`
- The type defining the parameter is the type that the kernel will interpret the value as.

Using `as -o main.o main.s` will invoke the assembler to take all the code you wrote and conver it to 1's and 0's that the processor will understand.

Next you run the linker `ld -o main main.o`. This will take the raw code and organize it in a way the operating system and processor expects it to be.

Finally run ./ main to execute the program.

Segmentation faults occur when trying to access memory that you do not have access to.

Registers are accessible directly by the processor.

Memory cannot be loaded directly into a processor. Instead, it is pulled into the registers and manipulated by the processor. The result is then set back into memory.

