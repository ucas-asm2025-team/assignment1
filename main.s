.globl _start
.extern isalpha, alpha, not_alpha, output, debug
.extern ch, max_id, max_siz

.section .text
_start:
while_cond:
    call    getchar
    movl    %eax, ch # let ch = getchar()
    cmpl    $-1, %eax
    je      while_end # jump ch == EOF ? while_end : if_cond
if_cond:
    movl    ch, %edi
    call    isalpha
    testl   %eax, %eax
    jz      else_stmt # jump isalpha(ch) ? if_stmt : else_stmt
if_stmt:
    call    alpha # call alpha()
    jmp     if_end
else_stmt:
    call    not_alpha # call not_alpha()
    jmp     if_end
if_end:
    jmp while_cond # end of loop, jump to condition
while_end:
    movl    $0, %esi # let counter %esi = 0
for_loop:
    cmpl    max_siz, %esi
    jge     for_end # if %esi >= max_siz then break
    movl    max_id(,%esi,4), %edi # let %edi = max_id[%esi]
    call    output # call output(max_id[%esi])
    incl    %esi # %esi++
    jmp     for_loop
for_end:
# if linked with c source debug.c, the debug() func will print all tree nodes
# otherwise, debug() will do nothing, just serves as a place holder.
    call    debug
    movl    $60, %eax
    xorl    %edi, %edi
    syscall
