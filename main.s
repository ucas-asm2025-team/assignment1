.globl _start
.extern isalpha, alpha, not_alpha, output, traverse
.extern ch

.section .text
_start:
while_cond:
    call    getchar
    movl    %eax, ch
    cmpl    $-1, %eax
    je      while_end
if_cond:
    pushl   ch
    call    isalpha
    addl    $4, %esp
    testl   %eax, %eax
    jz      else_stmt
if_stmt:
    call    alpha
    jmp     if_end
else_stmt:
    call    not_alpha
    jmp     if_end
if_end:
    jmp while_cond
while_end:
    call    traverse # for debug
    call    output
    movl    $1, %eax
    movl    $0, %ebx
    int     $0x80
