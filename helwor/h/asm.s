.global _start
.align 4

// x0 - x2 parameters to Unix system calls
// x16 - match system call to function call

// _start does not need to be placed above everything else.
// There could be a function or something else here

_start: mov x0, #1          // 1 = StdOut
        adr x1, helloworld  // string to print
        mov x2, #13         // length of string
        mov x16, #4         // Unix write system call
        svc #0x80           // Call kernel to output the string
    
// Set parameters to exit program 
// Call the kernel to do it

        mov x0, #0          // Use 0 return code, code completed succesfully
        mov x16, #1         // System call number 1 terminates this program 
        svc #0x80           // Call kernal to terminate the program

helloworld: .ascii "HelloWorld\n"
