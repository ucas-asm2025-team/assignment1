.globl _start
.extern isalpha, alpha, not_alpha, output, debug, fflush
.extern ch, max_id, max_siz

.section .text
_start:
.while_cond:
    call    getchar
    movl    %eax, ch(%rip) # let ch = getchar()
    cmpl    $-1, %eax
    je      .while_end # jump ch == EOF ? while_end : if_cond
.if_cond:
    movl    ch(%rip), %edi
    call    isalpha
    testl   %eax, %eax
    jz      .else_stmt # jump isalpha(ch) ? if_stmt : else_stmt
.if_stmt:
    call    alpha # call alpha()
    jmp     .if_end
.else_stmt:
    call    not_alpha # call not_alpha()
    jmp     .if_end
.if_end:
    jmp .while_cond # end of loop, jump to condition
.while_end:
    movq    $0, %rsi # let counter %rsi = 0
.for_loop:
    cmpl    max_siz(%rip), %esi
    jge     .for_end # if %esi >= max_siz then break
    leaq    max_id(%rip), %rdi # let %rdi = &max_id
    movl    (%rdi,%rsi,4), %edi # let %edi = max_id[%esi]
    movslq  %edi, %rdi # sign extend %edi to %rdi
    push    %rsi
    call    output # call output(max_id[%esi])
    pop     %rsi
    inc     %rsi # %esi++
    jmp     .for_loop
.for_end:
# if linked with c source debug.c, the debug() func will print all tree nodes
# otherwise, debug() will do nothing, just serves as a place holder.
    call    debug
    xor     %edi, %edi
    call    fflush # call fflush(NULL)
    movl    $60, %eax # syscall number for exit
    xorl    %edi, %edi # exit code 0
    syscall
