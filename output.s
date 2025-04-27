.equ    MAXL, 1000

.section .bss
        .lcomm  output_buffer, MAXL*2

# 全局符号，由C文件提供
        .extern content                 # char  content[]
        .extern father                  # int   father[]
        .extern puts

.section .text
        .globl  output
        .type   output, @function

#  void output(int id)
#  %edi 为参数 id
output:
        pushq   %rbp
        movq    %rsp, %rbp
        pushq   %rbx                    # callee-saved

        subq    $16, %rsp               # 局部变量留 16 字节
        movl    $0, -4(%rbp)            # int cnt = 0;

# 从叶子节点向根节点遍历，收集单词反序字母
.Lcollect:
        testl   %edi, %edi
        je      .Lreverse

        movl    -4(%rbp), %eax          # eax→rax = cnt（零扩展）
        lea     content(%rip), %rbx
        movzbl  (%rbx,%rdi,1), %ecx     # cl = content[id]

        lea     output_buffer(%rip), %rbx
        movb    %cl, (%rbx,%rax,1)      # output[cnt] = cl

        incl    -4(%rbp)                # ++cnt

        lea     father(%rip), %rbx
        movl    (%rbx,%rdi,4), %edi     # id = father[id]
        jmp     .Lcollect

# 收集到的字符串反转顺序，变为正序
.Lreverse:
        movl    -4(%rbp), %eax          # eax→rax = cnt
        movl    %eax, %edx              # edx→rdx = cnt
        decl    %eax                    # eax→rax = cnt-1

        lea     output_buffer(%rip), %rbx
        leaq    (%rbx,%rax,1), %rsi     # rsi = &output[cnt-1]
        leaq    (%rbx,%rdx,1), %rdi     # rdi = &output[cnt]
        movq    %rbx, %rcx              # rcx = &output[0]

.Lrev_loop:
        cmpq    %rcx, %rsi
        jb      .Lafter_reverse
        movzbl  (%rsi), %eax
        movb    %al, (%rdi)
        decq    %rsi
        incq    %rdi
        jmp     .Lrev_loop

# 终止符写入
.Lafter_reverse:
        movl    -4(%rbp), %eax
        sall    $1, %eax                # cnt * 2
        lea     output_buffer(%rip), %rbx
        movb    $0, (%rbx,%rax,1)       # '\0'

        /* ---------- 调用 puts ---------- */
        movl    -4(%rbp), %eax
        lea     output_buffer(%rip), %rdi
        leaq    (%rdi,%rax,1), %rdi     # rdi = 输出字符串地址

        subq    $8, %rsp                # 对齐栈 -> 16B
        call    puts@PLT
        addq    $8, %rsp

        popq    %rbx
        leave
        ret

