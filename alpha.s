.globl alpha
.extern ch, cur_id, tot, father, content, son  # 声明外部符号

# 定义CHARSET_SIZE常量
.equ CHARSET_SIZE, 128

.section .text
.type alpha, @function

alpha:
    pushq %rbp
    movq  %rsp, %rbp
    
    # 计算son[cur_id][ch]的地址
    movl  cur_id(%rip), %eax      # 加载cur_id到eax
    movl  ch(%rip), %ecx          # 加载ch到ecx
    imull $CHARSET_SIZE, %eax     # cur_id * CHARSET_SIZE 
    addl  %ecx, %eax              # eax = cur_id * CHARSET_SIZE + ch
    leaq  son(%rip), %rdx         # 获取son的基址
    movslq %eax, %rax             # 符号扩展，将eax扩展为64位存入rax
    leaq  (%rdx,%rax,4), %rsi     # rsi = &son[cur_id][ch]
    
    # 检查son[cur_id][ch]是否为0
    cmpl  $0, (%rsi)              # if (!son[cur_id][ch])
    jne   .skip_creation
    
    # 如果son[cur_id][ch]为0，创建新节点
    incl  tot(%rip)               # tot++
    movl  tot(%rip), %edx         # edx = tot
    
    # father[tot] = cur_id
    movl  cur_id(%rip), %ecx      
    leaq  father(%rip), %r8       # 获取father的基址
    movslq %edx, %r9              # 符号扩展，将edx扩展为64位
    movl  %ecx, (%r8,%r9,4)       # father[tot] = cur_id
    
    # content[tot] = ch
    movl  ch(%rip), %ecx
    leaq  content(%rip), %r8      # 获取content的基址
    movb  %cl, (%r8,%r9,1)        # content[tot] = ch
    
    # son[cur_id][ch] = tot
    movl  %edx, (%rsi)            # son[cur_id][ch] = tot
    
.skip_creation:
    # cur_id = son[cur_id][ch]
    movl  (%rsi), %eax            # eax = son[cur_id][ch]
    movl  %eax, cur_id(%rip)      # cur_id = son[cur_id][ch]
    
    leave
    ret
