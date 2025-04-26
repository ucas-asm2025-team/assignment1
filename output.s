.globl output

.section .bss
        .lcomm  output_buffer, MAXL*2

.section .text
        .globl  output
        .type   output, @function

output:
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $16, %rsp
        movl    $0, -4(%rbp)


.Lcollect:
        testl   %edi, %edi # while(id)
        je      .Lreverse

        movl    -4(%rbp), %eax
        movzbl  content(,%rdi,1), %ecx
        movb    %cl, output_buffer(,%rax,1)
        incl    -4(%rbp)

        movl    father(,%rdi,4), %edi
        jmp     .Lcollect

# 逆序
.Lreverse:
        movl    -4(%rbp), %eax
        movl    %eax, %edx
        decl    %eax

        leaq    output_buffer(,%rax,1), %rsi
        leaq    output_buffer(,%rdx,1), %rdi
        leaq    output_buffer, %rcx

.Lrev_loop:
        cmpq    %rcx, %rsi
        jb      .Lafter_reverse
        movzbl  (%rsi), %eax
        movb    %al, (%rdi)
        decq    %rsi
        incq    %rdi
        jmp     .Lrev_loop

# 终止符
.Lafter_reverse:
        movl    -4(%rbp), %eax
        sall    $1, %eax
        movb    $0, output_buffer(,%eax,1)

        movl    -4(%rbp), %eax
        leaq    output_buffer(,%rax,1), %rdi
        call    puts@PLT

        leave
        ret
