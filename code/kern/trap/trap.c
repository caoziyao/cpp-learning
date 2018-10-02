#include <types.h>
#include <x86.h>
#include <stdio.h>
#include <console.h>
#include <trap.h>
#include <clock.h>

// 紧接着第二步初步处理后，继续完成具体的各种中断处理操作；

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
//void
//idt_init(void) {
//    extern uintptr_t __vectors[];
//    int i;
//    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
//        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
//    }
//
//    // load the IDT
//    lidt(&idt_pd);
//}



/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
//    char c;
//
//    switch (tf->tf_trapno) {
//    case IRQ_OFFSET + IRQ_TIMER:
//        ticks ++;
//        if (ticks % TICK_NUM == 0) {
//            print_ticks();
//        }
//        break;
//    case IRQ_OFFSET + IRQ_COM1:
//        c = cons_getc();
//        cprintf("serial [%03d] %c\n", c, c);
//        break;
//    case IRQ_OFFSET + IRQ_KBD:
//        c = cons_getc();
//        cprintf("kbd [%03d] %c\n", c, c);
//        break;
//    default:
//        // in kernel, it must be a mistake
//        if ((tf->tf_cs & 3) == 0) {
//            print_trapframe(tf);
//            panic("unexpected trap in kernel.\n");
//        }
//    }
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
