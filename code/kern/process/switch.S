.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    # 保存了进程在返回switch_to函数后的指令地址到context.eip中
    movl 4(%esp), %eax          # eax points to from
    popl 0(%eax)                # save eip !popl

    # 保存前一个进程的其他7个寄存器到context中的相应域中
    movl %esp, 4(%eax)
    movl %ebx, 8(%eax)
    movl %ecx, 12(%eax)
    movl %edx, 16(%eax)
    movl %esi, 20(%eax)
    movl %edi, 24(%eax)
    movl %ebp, 28(%eax)

    # restore to's registers
    # context的高地址的域ebp开始，逐一把相关域的值赋值给对应的寄存器
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
                                # eax now points to to
    movl 28(%eax), %ebp
    movl 24(%eax), %edi
    movl 20(%eax), %esi
    movl 16(%eax), %edx
    movl 12(%eax), %ecx
    movl 8(%eax), %ebx
    movl 4(%eax), %esp

	# 把context中保存的下一个进程要执行的指令地址context.eip放到了堆栈顶
    pushl 0(%eax)               # push eip

	# 最后一条指令“ret”时，会把栈顶的内容赋值给EIP寄存器，这样就切换到下一个进程执行了
    ret

