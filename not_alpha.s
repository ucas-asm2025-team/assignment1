.globl not_alpha

.section .text
.type not_alpha, @function

not_alpha:
    pushq %rbp
    movq %rsp, %rbp
    pushq %rbx                    # 保存%rbx寄存器

    # 通过GOT访问全局变量（64位PIC）
    movq cur_id@GOTPCREL(%rip), %rax  # 获取cur_id的地址
    movl (%rax), %eax            # 读取cur_id的值
    testl %eax, %eax
    jz .exit

    # 处理cnt数组
    movq cnt@GOTPCREL(%rip), %rsi     # 获取cnt数组基地址
    leaq (%rsi, %rax, 4), %rsi        # 计算cnt[cur_id]地址
    incl (%rsi)                       # cnt[cur_id]++

    # 处理max_cnt
    movq max_cnt@GOTPCREL(%rip), %rcx # 获取max_cnt的地址
    movl (%rcx), %edx                 # 读取max_cnt的值
    cmpl %edx, (%rsi)
    jle .no_update

    movl (%rsi), %edx                 # 更新max_cnt
    movl %edx, (%rcx)
    movq max_id@GOTPCREL(%rip), %rcx  # 获取max_id的地址
    movl %eax, (%rcx)

.no_update:
    movq cur_id@GOTPCREL(%rip), %rcx  # 获取cur_id的地址
    movl $0, (%rcx)                   # cur_id = 0

.exit:
    popq %rbx                        # 恢复%rbx
    leaveq
    retq

    
