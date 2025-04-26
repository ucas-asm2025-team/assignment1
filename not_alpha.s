.globl not_alpha

.section .text
.type not_alpha, @function

not_alpha:
    pushl %ebp
    movl  %esp, %ebp

    
    movl  cur_id, %eax
    testl %eax, %eax
    jz    .exit                             

   
    leal  cnt(,%eax,4), %esi              
    incl  (%esi)                           
    movl  max_cnt, %ebx
    cmpl  %ebx, (%esi)
    jle   .no_update
    movl  (%esi), %ebx                      
    movl  %ebx, max_cnt
    movl  %eax, max_id                      

.no_update:
  
    movl  $0, cur_id

.exit:
    leave
    ret
    
