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
/*
 * 中断门描述符表（IDT）， 每个 8 字节
struct gatedesc {
	unsigned gd_off_15_0 : 16;      // low 16 bits of offset in segment
	unsigned gd_ss : 16;            // segment selector 中断服务例程的段选择子
	unsigned gd_args : 5;           // # args, 0 for interrupt/trap gates
	unsigned gd_rsv1 : 3;           // reserved(should be zero I guess)
	unsigned gd_type : 4;           // type(STS_{TG,IG32,TG32})
	unsigned gd_s : 1;              // must be 0 (system)
	unsigned gd_dpl : 2;            // descriptor(meaning new) privilege level
	unsigned gd_p : 1;              // Present
	unsigned gd_off_31_16 : 16;     // high bits of offset in segment 。偏移量
gd_off_31_16 作用是： CPU使用IDT查到的中断服务例程的段选择子从GDT（全局描述符表）中取得相应的段描述符，
段描述符里保存了中断服务例程的段基址和属性信息，段描述符的基址+中断描述符中的偏移地址形成了中断服务例程的起始地址；
};
 * */

/*
 * 任务门（task gate），当中断信号发生时，必须取代当前进程地那个进程地TSS选择符存放在任务门中。
中断门（interrupt gate），包含段选择符和中断或异常处理程序地段内偏移量，当控制权转移到一个适当地段时，处理器清IF标志，从而关闭将来会发生的可屏蔽中断。
陷阱门（trap gate），和中断门类似，只是控制权传递到一个适当地段处理器不修改IF标志。
 * */
static struct gatedesc idt[256] = {{0}};

/*
 * IDT寄存器（IDTR）的内容来寻址IDT的起始地址
 * struct pseudodesc {
    uint16_t pd_lim;        // Limit 大小
    uintptr_t pd_base;      // Base address 基地址
} __attribute__ ((packed));
 * */
static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uint32_t)idt
};

/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

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

    // 建立好中断门描述符表后，通过指令 lidt 把中断门描述符表的起始地址装入IDTR寄存器中，从而完成中段描述符表的初始化工作。
    // load the IDT
    lidt(&idt_pd);
    /*
     * 读由idtr寄存器指向的IDT表中的第i项门描述符。
从gdtr寄存器获得GDT的基地址，并在GDT中查找，以读取IDT表项中的选择符所标识的段描述符，这个描述符指定只哦你果断或异常处理程序所在的段的基地址。
     * */
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
    case T_SWITCH_TOU:
		if (tf->tf_cs != USER_CS) {
			switchk2u = *tf;
			switchk2u.tf_cs = USER_CS;
			switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
			switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;

			// set eflags, make sure ucore can use io under user mode.
			// if CPL > IOPL, then cpu will generate a general protection.
			switchk2u.tf_eflags |= FL_IOPL_MASK;

			// set temporary stack
			// then iret will jump to the right stack
			*((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
		}
		break;
	case T_SWITCH_TOK:
		//发出中断时，CPU处于用户态，我们希望处理完此中断后，CPU继续在内核态运行，
		//所以把tf->tf_cs和tf->tf_ds都设置为内核代码段和内核数据段
		if (tf->tf_cs != KERNEL_CS) {
			tf->tf_cs = KERNEL_CS;
			tf->tf_ds = tf->tf_es = KERNEL_DS;
			//设置EFLAGS，让用户态不能执行in/out指令
			tf->tf_eflags &= ~FL_IOPL_MASK;
			switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
			 //设置临时栈，指向switchu2k，这样iret返回时，CPU会从switchu2k恢复数据，
			//而不是从现有栈恢复数据。
			memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
			*((uint32_t *)tf - 1) = (uint32_t)switchu2k;
		}
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
