#include <types.h>
#include <x86.h>
#include <picirq.h>
// 实现了对中断控制器8259A的初始化和使能操作

// I/O Addresses of the two programmable interrupt controllers
#define IO_PIC1             0x20    // Master (IRQs 0-7)
#define IO_PIC2             0xA0    // Slave (IRQs 8-15)

#define IRQ_SLAVE           2       // IRQ at which slave connects to master

// Current IRQ mask.
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
    irq_mask = mask;
    if (did_init) {
        outb(IO_PIC1 + 1, mask);
        outb(IO_PIC2 + 1, mask >> 8);
    }
}

void
pic_enable(unsigned int irq) {
    pic_setmask(irq_mask & ~(1 << irq));
}

/*
 * ICW1：初始化命令字。
ICW2：中断向量寄存器，初始化时写入高五位作为中断向量的高五位，然后在中断响应时由8259根据中断源（哪个管脚）自动填入形成完整的8位中断向量（或叫中断类型号）。
ICW3： 8259的级联命令字，用来区分主片和从片。
ICW4：指定中断嵌套方式、数据缓冲选择、中断结束方式和CPU类型。
 * */
/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
    did_init = 1;

    // 此时系统尚未初始化完毕，故屏蔽主从8259A的所有中断
    // mask all interrupts
    outb(IO_PIC1 + 1, 0xFF);
    outb(IO_PIC2 + 1, 0xFF);

    // Set up master (8259A-1)

    /*
     * 设置主8259A的ICW1，给ICW1写入0x11，0x11表示
     * （1）外部中断请求信号为上升沿触发有效，
     * （2）系统中有多片8295A级联，
     * （3）还表示要向ICW4送数据
     * */
    // ICW1:  0001g0hi
    //    g:  0 = edge triggering, 1 = level triggering
    //    h:  0 = cascaded PICs, 1 = master only
    //    i:  0 = no ICW4, 1 = ICW4 required
    outb(IO_PIC1, 0x11);

    /*
     * 设置主8259A的ICW2:  给ICW2写入0x20，设置中断向量偏移值为0x20，即把主8259A的IRQ0-7映射到向量0x20-0x27
     * */
    // ICW2:  Vector offset
    outb(IO_PIC1 + 1, IRQ_OFFSET);

    /*
     *  设置主8259A的ICW3:  ICW3是8259A的级联命令字，给ICW3写入0x4，0x4表示此主中断控制器的第2个IR线（从0开始计数）连接从中断控制器。
     * */
    // ICW3:  (master PIC) bit mask of IR lines connected to slaves
    //        (slave PIC) 3-bit # of slave's connection to master
    outb(IO_PIC1 + 1, 1 << IRQ_SLAVE);

    /*
     * 设置主8259A的ICW4：给ICW4写入0x3，0x3表示采用自动EOI方式，即在中断响应时，在8259A送出中断矢量后，自动将ISR相应位复位；并且采用一般嵌套方式，即当某个中断正在服务时，本级中断及更低级的中断都被屏蔽，只有更高的中断才能响应。
     *
     * */
    // ICW4:  000nbmap
    //    n:  1 = special fully nested mode
    //    b:  1 = buffered mode
    //    m:  0 = slave PIC, 1 = master PIC
    //        (ignored when b is 0, as the master/slave role
    //         can be hardwired).
    //    a:  1 = Automatic EOI mode
    //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
    outb(IO_PIC1 + 1, 0x3);

    // Set up slave (8259A-2)
    outb(IO_PIC2, 0x11);    // ICW1
    outb(IO_PIC2 + 1, IRQ_OFFSET + 8);  // ICW2
    outb(IO_PIC2 + 1, IRQ_SLAVE);   // ICW3
    // NB Automatic EOI mode doesn't tend to work on the slave.
    // Linux source code says it's "to be investigated".
    outb(IO_PIC2 + 1, 0x3); // ICW4

    // OCW3:  0ef01prs
    //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
    //    p:  0 = no polling, 1 = polling mode
    //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
    outb(IO_PIC1, 0x68);    // clear specific mask
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    // 初始化完毕，使能主从8259A的所有中断
    if (irq_mask != 0xFFFF) {
        pic_setmask(irq_mask);
    }
}

