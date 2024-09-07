// Program 1: Exiting
// Simple Apple Silicon assembly program that exits gracefully

.global _main
.align 2

_main:
    mov     x0,  #0      // 0 = no error
    mov     x16, #1
    svc     #0x80

