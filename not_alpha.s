.globl not_alpha

.section .text
.type not_alpha, @function

not_alpha:
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %rbx
    pushq   %r12
    pushq   %r13

    # 访问全局变量（64位PIC）
    movq    cur_id@GOTPCREL(%rip), %rax
    movl    (%rax), %eax            # eax = cur_id
    testl   %eax, %eax
    jz      .exit

    # cnt[cur_id]++
    movq    cnt@GOTPCREL(%rip), %rcx
    movl    (%rcx, %rax, 4), %edx   # edx = cnt[cur_id]
    incl    %edx
    movl    %edx, (%rcx, %rax, 4)   # cnt[cur_id]++

    # 处理max_cnt逻辑
    movq    max_cnt@GOTPCREL(%rip), %r8
    movl    (%r8), %r9d             # r9d = max_cnt
    cmpl    %r9d, %edx
    jle     .check_equal

    # 更新max_cnt并重置max_siz
    movq    max_siz@GOTPCREL(%rip), %r10
    movl    %edx, (%r8)             # max_cnt = cnt[cur_id]
    movl    $0, (%r10)              # max_siz = 0

.check_equal:
    cmpl    %r9d, %edx              # 比较cnt[cur_id]与原max_cnt
    jl      .clear_id

    # 将cur_id添加到max_id数组
    movq    max_siz@GOTPCREL(%rip), %r11
    movl    (%r11), %ebx            # ebx = max_siz
    movq    max_id@GOTPCREL(%rip), %r12
    movl    %eax, (%r12, %rbx, 4)   # max_id[max_siz] = cur_id
    incl    (%r11)                  # max_siz++

.clear_id:
    # cur_id = 0
    movq    cur_id@GOTPCREL(%rip), %r13
    movl    $0, (%r13)

.exit:
    popq    %r13
    popq    %r12
    popq    %rbx
    leaveq
    retq
    
