.globl _start
.extern puts, hello_msg

.section .text
_start:
    pushl   $hello_msg
    call    puts
    addl    $4, %esp

    movl    $1, %eax
    movl    $0, %ebx
    int     $0x80
