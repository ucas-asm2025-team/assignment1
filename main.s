.globl _start
.extern isalpha, alpha, not_alpha, output, traverse
.extern ch, max_id, max_siz

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
    movl    $0, %esi
    xorl    %esi, %esi
for_loop:
    cmpl    max_siz, %esi
    jge     for_end
    movl    max_id(,%esi,4), %eax
    pushl   %eax
    call    output
    addl    $4, %esp
    incl    %esi
    jmp     for_loop
for_end:
    call    traverse             # for debug
    movl    $1, %eax
    movl    $0, %ebx
    int     $0x80
