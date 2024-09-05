.global _fn 
// .type is omitted because it is not recognized on Apple silicon
.align 2

_fn: 
    // Operation code (opcode): add
    // Three Operands: x1, x0, #1
    add x0, x0, x1 
    ret

