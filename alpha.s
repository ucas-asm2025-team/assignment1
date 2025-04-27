.code32
.globl alpha
.extern ch, cur_id, tot, father, content, son  # 声明外部符号

# 定义CHARSET_SIZE常量
.equ CHARSET_SIZE, 128

.section .text
.type alpha, @function

alpha:
    push %ebp
    movl  %esp, %ebp
    
    # 计算son[cur_id][ch]的地址
    movl  cur_id, %eax            # 加载cur_id到eax
    movl  ch, %ecx                # 加载ch到ecx
    imull $CHARSET_SIZE, %eax     # cur_id * CHARSET_SIZE 
    addl  %ecx, %eax              # eax = cur_id * CHARSET_SIZE + ch
    leal  son(,%eax,4), %esi      # esi = &son[cur_id][ch]
    
    # 检查son[cur_id][ch]是否为0
    cmpl  $0, (%esi)              # if (!son[cur_id][ch])
    jne   .skip_creation
    
    # 如果son[cur_id][ch]为0，创建新节点
    incl  tot                     # tot++
    movl  tot, %edx               # edx = tot
    
    # father[tot] = cur_id
    movl  cur_id, %ecx            
    movl  %ecx, father(,%edx,4)   # father[tot] = cur_id
    
    # content[tot] = ch
    movl  ch, %ecx
    movb  %cl, content(,%edx,1)   # content[tot] = ch
    
    # son[cur_id][ch] = tot
    movl  %edx, (%esi)            # son[cur_id][ch] = tot
    
.skip_creation:
    # cur_id = son[cur_id][ch]
    movl  (%esi), %eax            # eax = son[cur_id][ch]
    movl  %eax, cur_id            # cur_id = son[cur_id][ch]
    
    leave
    ret
