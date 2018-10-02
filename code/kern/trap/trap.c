#include <types.h>
#include <x86.h>
#include <mmu.h>
#include <memlayout.h>
#include <stdio.h>
#include <console.h>
#include <trap.h>
#include <clock.h>
// 紧接着第二步初步处理后，继续完成具体的各种中断处理操作；

#define TICK_NUM 100

/* *
 * Interrupt descriptor table:
 *
 * Must be built at run time because shifted function addresses can't
 * be represented in relocation records.
 * */
// 全局变量：中断门描述符表
static struct gatedesc idt[256] = {{0}};

static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uint32_t)idt
};


static void print_ticks() {
    cprintf("ticks\n");
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    cprintf("EOT: kernel seems ok.");
#endif
}


/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {

	// 保存在vectors.S中的256个中断处理例程的入口地址数组
    extern uintptr_t __vectors[];

    // 在中断门描述符表中通过建立中断门描述符，其中存储了中断处理例程的代码段GD_KTEXT和偏移量\__vectors[i]，特权级为DPL_KERNEL。这样通过查询idt[i]就可定位到中断服务例程的起始地址。
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }

    // 建立好中断门描述符表后，通过指令lidt把中断门描述符表的起始地址装入IDTR寄存器中，从而完成中段描述符表的初始化工作。
    // load the IDT
    lidt(&idt_pd);
}



/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
    char c;

    switch (tf->tf_trapno) {
    case IRQ_OFFSET + IRQ_TIMER:
        ticks ++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
        cprintf("serial \n");
        break;
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
        cprintf("kbd \n");
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
        	cprintf("in kernel, it must be a mistake \n");
//            print_trapframe(tf);
//            panic("unexpected trap in kernel.\n");
        }
    }
}


/* *
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
    trap_dispatch(tf);
}
