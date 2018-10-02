#include <types.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <console.h>
#include <picirq.h>
#include <trap.h>
#include <clock.h>
#include <intr.h>

// qemu-system-i386 -hda bin/ucore.img -S -s
// x86_64-linux-gnu-gdb bin/kernel
// target remote :1234
// break kern_init
 int kern_init(void) __attribute__((noreturn));
 static void switch_test(void);

void init_driver() {
	cons_init();                // init the console, 对串口、键盘和时钟外设的中断初始化
	pic_init();                 // init interrupt controller, 中断控制器的初始化工作
	idt_init();                 // init interrupt descriptor table, 对整个中断门描述符表的创建
	intr_enable();				 // enable irq interrupt
//	sti();
}


void unite_test() {
	testmain();
}


int
kern_init(void) {
	init_driver();
	unite_test();
	int a = 1;
	a = a + 3;
	char *s = "ddss";
	int l = strlen(s);

	const char *msg = "hello lmo-os";
	cprintf(msg);

	// user/kernel mode switch test
//	    switch_test();

     while (1);
//		return 0;
}

static void
switch_to_user(void) {
    asm volatile ("int %0\n" :: "i" (T_SWITCH_TOU));  // 120
}

static void
switch_to_kernel(void) {
    asm volatile ("int %0\n" :: "i" (T_SWITCH_TOK));  // 121
}


static void
switch_test(void) {
//    print_cur_status();
    cprintf("+++ switch to  user  mode +++\n");
    switch_to_user();
//    print_cur_status();
    cprintf("+++ switch to kernel mode +++\n");
    switch_to_kernel();
//    print_cur_status();
}

