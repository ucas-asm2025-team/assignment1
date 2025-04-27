.globl not_alpha

.section .text
.code32
.type not_alpha, @function

not_alpha:
    push %ebp
    movl %esp, %ebp
    push %ebx                    # 保存%ebx寄存器

    call .get_got                # 获取当前指令地址到栈
.get_got:
    pop %ebx                     # %ebx = 当前地址
    addl $_GLOBAL_OFFSET_TABLE_ + (.get_got - not_alpha), %ebx  # 计算GOT基地址

    # 通过GOT访问全局变量
    movl cur_id@GOT(%ebx), %eax  # 获取cur_id的地址
    movl (%eax), %eax            # 读取cur_id的值
    testl %eax, %eax
    jz .exit

    # 处理cnt数组
    movl cnt@GOT(%ebx), %esi     # 获取cnt数组基地址
    leal (%esi, %eax, 4), %esi   # 计算cnt[cur_id]地址
    incl (%esi)                  # cnt[cur_id]++

    # 处理max_cnt
    movl max_cnt@GOT(%ebx), %ecx # 获取max_cnt的地址
    movl (%ecx), %edx            # 读取max_cnt的值
    cmpl %edx, (%esi)
    jle .no_update

    movl (%esi), %edx            # 更新max_cnt
    movl %edx, (%ecx)
    movl max_id@GOT(%ebx), %ecx  # 获取max_id的地址
    movl %eax, (%ecx)

.no_update:
    movl cur_id@GOT(%ebx), %ecx  # 获取cur_id的地址
    movl $0, (%ecx)              # cur_id = 0

.exit:
    pop %ebx                     # 恢复%ebx
    leave
    ret
    
    
